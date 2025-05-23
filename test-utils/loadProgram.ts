// beargrease/test-utils/loadProgram.ts

import { Program, AnchorProvider, Idl } from "@coral-xyz/anchor";
import { PublicKey } from "@solana/web3.js";
import fs from "fs";
import path from "path";

/**
 * Load an Anchor Program by reading its IDL and program ID fro Anchor.toml
 */

export async function loadProgram(programName: string): Promise<Program<Idl>> {
    // 🔍 Step 1: Parse program ID from Anchor.toml
    const anchorToml = fs.readFileSync(path.resolve("Anchor.toml"), "utf8");
    const match = anchorToml.match(new RegExp(`${programName}\\s*=\\s*"([^"]+)"`));
    if (!match) throw new Error(`❌ Could not find program ID for #${programName}" in Anchor..toml`);
    const programId = new PublicKey(match[1]);

    // 📦 Step 2: Import IDL JSON using ESM dynamic import
    const idlPath = path.resolve("target", "idl", `${programName}.json`);
    const rawIdl = await import(idlPath, { assert: { type: "json" } });
    const idl: Idl = rawIdl.default;

    // 🔌 Step 3: Load provider and return constructed Program
    const provider = AnchorProvider.env();
    return new Program(idl, programId, provider);
}
    