import { AnchorProvider, Program } from "@coral-xyz/anchor";
import type { Idl } from "@coral-xyz/anchor";
import path from "path";
import fs from "fs/promises";

/**
 * Loads an Anchor Program instance from its IDL and environment.
 * Requires that the IDL includes the program ID in `metadata.address`
 * as expected by Anchor v0.31.1.
 *
 * @param programName - The name of the program (used to locate `target/idl/{name}.json`)
 * @returns A typed Anchor Program instance.
 */
export async function loadProgram<IDL extends Idl>(programName: string): Promise<Program<IDL>> {
  const idlPath = path.resolve("target", "idl", `${programName}.json`);
  const rawJson = await fs.readFile(idlPath, "utf8");
  const idl: IDL = JSON.parse(rawJson);

  const metadata = (idl as any).metadata;
  const programId = metadata?.address;

  if (typeof programId !== "string") {
    throw new Error(`❌ IDL for "${programName}" must include a valid program ID in metadata.address`);
  }

  const provider = AnchorProvider.env();
  return new Program<IDL>(idl, provider);
}
