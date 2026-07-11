import crypto from "node:crypto";
import { appendRecord, readRecords, verifyRecordChain, sha256 } from "./storage.js";

export async function writeReceipt(type, payload, context = {}) {
  if (!/^[a-z0-9][a-z0-9_.:-]{1,80}$/i.test(String(type || ""))) throw new Error("invalid_receipt_type");
  const receipt = {
    schema: "nova-platform-receipt-v0.2",
    receiptId: `nova_receipt_${Date.now()}_${crypto.randomBytes(6).toString("hex")}`,
    type,
    createdAt: new Date().toISOString(),
    context: {
      surface: context.surface || "nova-app-platform",
      operator: context.operator || null,
      requestId: context.requestId || null
    },
    payloadHash: sha256(payload || {}),
    payload
  };
  const record = await appendRecord("receipts", receipt, { id: receipt.receiptId });
  return { ...receipt, recordHash: record.recordHash, previousHash: record.previousHash };
}

export async function listReceipts({ limit = 100 } = {}) {
  const records = await readRecords("receipts", { limit });
  return records.map((record) => ({ ...record.payload, recordHash: record.recordHash, previousHash: record.previousHash }));
}

export async function receiptChainStatus() {
  const records = await readRecords("receipts", { limit: 10000 });
  return verifyRecordChain(records);
}
