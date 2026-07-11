import { appendRecord, readRecords, verifyRecordChain, sha256 } from "./storage.js";

export async function writeReceipt(type, payload, options = {}) {
  if (!/^[a-z0-9][a-z0-9_.:-]{1,80}$/i.test(String(type || ""))) throw new Error("invalid_receipt_type");
  const receipt = {
    schema: "nova-platform-receipt-v0.2",
    type,
    payload,
    actor: options.actor || "local-operator",
    surface: options.surface || "nova-app-platform",
    payloadHash: sha256(payload),
    createdAt: new Date().toISOString()
  };
  return appendRecord("receipts", receipt);
}

export async function listReceipts({ limit = 100 } = {}) {
  return readRecords("receipts", { limit });
}

export async function receiptChainStatus() {
  const records = await readRecords("receipts", { limit: 10000 });
  return verifyRecordChain(records);
}
