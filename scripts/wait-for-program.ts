// scripts/wait-for-program.ts
import { AnchorProvider, Wallet, setProvider } from "@coral-xyz/anchor";
import { Connection, Keypair, Transaction, PublicKey } from "@solana/web3.js";
import fs from "fs";
import path from "path";

// Local file paths
const IDL_PATH = path.join("target", "idl", "placebo.json");
const WALLET_PATH = process.env.ANCHOR_WALLET || ".ledger/wallets/test-user.json";

(async () => {
  // Load wallet keypair
  const secretKey = Uint8Array.from(
    JSON.parse(fs.readFileSync(WALLET_PATH, "utf-8"))
  );
  const wallet = new Wallet(Keypair.fromSecretKey(secretKey));

  // Set provider
  const connection = new Connection("http://localhost:8899", "confirmed");
  const provider = new AnchorProvider(connection, wallet, {});
  setProvider(provider);

  // Load program ID from IDL
  const idl = JSON.parse(fs.readFileSync(IDL_PATH, "utf-8"));
  const programIdStr = idl?.metadata?.address;
  if (!programIdStr) {
    console.error("❌ IDL is missing metadata.address field");
    process.exit(1);
  }
  const programId = new PublicKey(programIdStr);

  // 🪄 Kick the validator: send two dummy transactions
  try {
    const tx1 = await provider.sendAndConfirm(new Transaction());
    console.log("🧪 Dummy transaction 1 sent:", tx1);
    const tx2 = await provider.sendAndConfirm(new Transaction());
    console.log("🧪 Dummy transaction 2 sent:", tx2);
  } catch (err) {
    const msg = err instanceof Error ? err.message : JSON.stringify(err, null, 2);
    console.warn("⚠️ Dummy transaction(s) failed (non-fatal):", msg);
  }

  // ⏳ Wait for program to be indexed using getProgramAccounts
  for (let i = 1; i <= 90; i++) {
    try {
      await connection.getProgramAccounts(programId);
      console.log(`✅ Program is ready after ${i} attempt(s).`);
      process.exit(0);
    } catch (err: any) {
      const msg = err?.message || JSON.stringify(err, null, 2);
      if (msg.includes("Program does not exist")) {
        console.log(`⏳ Attempt ${i}/90: Program not yet ready (not indexed)...`);
        await new Promise((r) => setTimeout(r, 1000));
      } else {
        console.error("❌ Unexpected readiness check error:", msg);
        process.exit(1);
      }
    }
  }

  console.error("❌ Timed out waiting for program to be ready.");
  process.exit(1);
})();
