import { AnchorProvider, Program } from "@coral-xyz/anchor";
import type { Idl } from "@coral-xyz/anchor";
import path from "path";
import fs from "fs/promises";

/**
 * Loads an Anchor Program instance from its IDL and environment.
 * 
 * @param programName - The name of the program (used to locate `target/idl/{name}.json`)
 * @returns A typed Anchor Program instance.
 */
export async function loadProgram<IDL extends Idl>(programName: string): Promise<Program<IDL>> {
    const idlPath = path.resolve("target", "idl", `${programName}.json`);
    const rawJson = await fs.readFile(idlPath, "utf8");
    const idl: IDL = JSON.parse(rawJson);

    const provider = AnchorProvider.env();
    return new Program<IDL>(idl, provider);
}