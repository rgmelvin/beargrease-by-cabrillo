import { AnchorProvider, Program } from "@coral-xyz/anchor";
import type { Idl } from "@coral-xyz/anchor";
import { readFileSync } from "fs";
import path from "path";

/**
 * Dynamically loads and returns a Program instance for the given Anchor program.
 * @param programName 
 * 
 */

export async function getProgram(programName: string): Promise<Program<Idl>> {

  // Step 1: Load IDL file from /target/idl
  const idlPath = path.resolve("target", "idl", `${programName}.json`);
  const rawIdl = readFileSync(idlPath, "utf8");
  const idl: Idl = JSON.parse(rawIdl);

  // Step 2: Use the embedded address field in the IDL (Anchor v0.30+)
  const provider = AnchorProvider.env();
  return new Program<Idl>(idl, provider);
}
