import crypto from "node:crypto";
import { appendRecord } from "./storage.js";

export function sha256(value) {
  return crypto.createHash("sha256").update(JSON.stringify(value)).digest("hex");
}

export async function writeReceipt(type, payload) {
  const receipt = {
    id: `nova_receipt_${Date.now()}_${crypto.randomBytes(4).toString("hex")}`,
    type,
    createdAt: new Date().toISOString(),
    payload,
    hash: sha256({ type, payload })
  };
  await appendRecord("receipts", receipt);
  return receipt;
}
