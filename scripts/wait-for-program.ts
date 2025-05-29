import { AnchorProvider, Program, setProvider } from "@coral-xyz/anchor";
import { PublicKey, Transaction } from "@solana/web3.js";
import { readFileSync } from "fs";
import path from "path";

// Optional: For debugging or validation
function getProgramId(): PublicKey {
  const anchorToml = readFileSync(path.resolve("Anchor.toml"), "utf8");
  const match = anchorToml.match(/placebo\s*=\s*"([^"]+)"/);
  if (!match) throw new Error("❌ Could not extract program ID from Anchor.toml");
  return new PublicKey(match[1]);
}

// 🧪 Retry sending say_hello until expected log appears
async function waitForExecutionReadiness(program: Program): Promise<void> {
  const MAX_ATTEMPTS = 30;
  const DELAY_MS = 4000;
  const EXPECTED_LOG = "Program log: 👋 Hello from Placebo!";

  // We are using AnchorProvider.env(), so sendAndConfirm is guaranteed to be present
  const provider = program.provider as Required<typeof program.provider>;

  for (let attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
    try {
      console.log(`🔁 Attempt ${attempt}/${MAX_ATTEMPTS}: sending say_hello...`);

      const ix = await program.methods.sayHello().instruction();
      const tx = new Transaction().add(ix);

      const sig = await provider.sendAndConfirm(tx);

      const confirmed = await provider.connection.getParsedTransaction(sig, {
        commitment: "confirmed",
      });

      const logs = confirmed?.meta?.logMessages || [];
      if (logs.some((line) => line.includes(EXPECTED_LOG))) {
        console.log(`✅ Program log detected: "${EXPECTED_LOG}"`);
        return;
      } else {
        console.log(`⚠️  Log not yet found. Retrying in ${DELAY_MS / 1000}s...`);
      }
    } catch (err) {
      console.log(`⚠️  Transaction failed (attempt ${attempt}): ${(err as Error).message}`);
    }

    await new Promise((r) => setTimeout(r, DELAY_MS));
  }

  throw new Error(`❌ Failed to detect expected program log after ${MAX_ATTEMPTS} attempts`);
}

// 🚀 Entry point
(async function main() {
  try {
    const idlPath = path.resolve("target/idl/placebo.json");
    const idl = JSON.parse(readFileSync(idlPath, "utf8"));

    console.log("🧬 IDL program ID:", idl?.metadata?.address);

    const provider = AnchorProvider.env();
    setProvider(provider);

    const program = new Program<typeof idl>(idl, provider);

    console.log("🧪 Probing validator for execution readiness using say_hello...");
    await waitForExecutionReadiness(program);
  } catch (err) {
    console.error("❌ Unhandled error in wait-for-program.ts");

    if (err instanceof Error) {
      console.error(err.stack);
    } else {
      console.error("Thrown value is not an Error instance:", JSON.stringify(err, null, 2));
    }

    process.exit(1);
  }
})();
