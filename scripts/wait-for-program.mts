// scripts/wait-for-program.ts
import { AnchorProvider, Program, Wallet, setProvider } from "@coral-xyz/anchor";
import { Connection, Keypair } from "@solana/web3.js";
import fs from "fs";
import path from "path";

// Local file paths
const IDL_PATH = path.join("target", "idl", "placebo.json");
const WALLET_PATH = process.env.ANCHOR_WALLET || ".ledger/wallets/test-user.json";

async function main() {
  // Load IDL and wallet
  const idl = JSON.parse(fs.readFileSync(IDL_PATH, "utf-8"));
  const secretKey = Uint8Array.from(JSON.parse(fs.readFileSync(WALLET_PATH, "utf-8")));
  const wallet = new Wallet(Keypair.fromSecretKey(secretKey));

  // Create provider and set as global context
  const connection = new Connection("http://localhost:8899", "confirmed");
  const provider = new AnchorProvider(connection, wallet, {});
  setProvider(provider);

  // Get program ID from IDL metadata
  const programId = idl.metadata?.address;
  if (!programId) {
    console.error("❌ IDL is missing metadata.address field");
    process.exit(1);
  }

  // Create program using Anchor v0.31.1-compatible constructor
  const program = new Program(idl as any, provider);

  // Retry simulation up to 90 times
  for (let i = 1; i <= 90; i++) {
    try {
      // MInimal no-op simulation to confirm validator indexing
      await provider.connection.getProgramAccounts(program.programId);
      console.log(`✅ Program is ready after ${i} attempt(s).`);
      process.exit(0);
    } catch (err: any) {
      if (err.message?.includes("Program does not exist")) {
        console.log(`⏳ Attempt ${i}/90: Program not yet ready...`);
        await new Promise((r) => setTimeout(r, 1000));
      } else {
        console.error("❌ Unexpected simulation error:", err.message);
        process.exit(1);
      }
    }
  }

  console.error("❌ Timed out waiting for program to be ready.");
  process.exit(1);
}

main().catch((err) => {
  console.error("❌ wait-for-program.mts failed:",
    err instanceof Error
      ? err.message
      : typeof err === "string"
        ? err
        : JSON.stringify(err, null, 2));
  process.exit(1);
});
