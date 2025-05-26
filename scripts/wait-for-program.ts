import { AnchorProvider, Program, setProvider } from "@coral-xyz/anchor";
import { PublicKey, Keypair } from "@solana/web3.js";
import { readFileSync } from "fs";
import * as anchor from "@coral-xyz/anchor";
import path from "path";

// ⛑️ 1. Read program ID from Anchor.toml
function getProgramId(): PublicKey {
  const anchorToml = readFileSync(path.resolve("Anchor.toml"), "utf8");
  const match = anchorToml.match(/placebo\s*=\s*"([^"]+)"/);
  if (!match) throw new Error("❌ Could not extract program ID from Anchor.toml");
  return new PublicKey(match[1]);
}

// 🧪 2. Retry sending say_hello until expected log appears
async function waitForExecutionReadiness(program: Program): Promise<void> {
  const MAX_ATTEMPTS = 20;
  const DELAY_MS = 3000;
  const EXPECTED_LOG = "Program log: 👋 Hello from Placebo!";

  for (let attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
    try {
      console.log(`🔁 Attempt ${attempt}/${MAX_ATTEMPTS}: sending say_hello...`);
      const txSig = await program.methods.sayHello().rpc();
      const tx = await program.provider.connection.getParsedTransaction(txSig, {
        maxSupportedTransactionVersion: 0,
        commitment: "confirmed",
      });

      const logs = tx?.meta?.logMessages || [];
      if (logs.some((line) => line.includes(EXPECTED_LOG))) {
        console.log(`✅ Program log detected: "${EXPECTED_LOG}"`);
        return;
      } else {
        console.log(`⚠️  Log not yet found. Retrying in ${DELAY_MS / 1000}s...`);
      }
    } catch (err) {
      console.log(`⚠️  Transaction failed (attempt ${attempt}): ${err.message}`);
    }

    await new Promise((r) => setTimeout(r, DELAY_MS));
  }

  throw new Error(`❌ Failed to detect expected program log after ${MAX_ATTEMPTS} attempts`);
}

// 🚀 3. Main
(async () => {
  try {
    const programId = getProgramId();
    const idl = JSON.parse(readFileSync(path.resolve("target/idl/placebo.json"), "utf8"));

    const provider = AnchorProvider.env();
    setProvider(provider);

    const program = new Program(idl, provider);

    console.log("🧪 Probing validator for execution readiness using say_hello...");
    await waitForExecutionReadiness(program);
  } catch (err) {
    console.error("❌ Unhandled error in wait-for-program.ts");

    if (err instance of Error) {
      console.error(err.stack);
    } else {
      console.error("Thrown value is not an Error instance:", JSON.stringify(err, null, 2));
    }
    
    console.error(err);
    process.exit(1);
  }
})();
