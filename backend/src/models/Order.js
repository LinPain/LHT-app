const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  orderNumber: { type: String, unique: true },
  customer: { type: mongoose.Schema.Types.ObjectId, ref: 'Customer', default: null },
  branchId: { type: String, default: '' },
  orderType: { type: String, default: 'TAKEAWAY' },
  source: { type: String, default: 'APP' },
  customerName: String,
  customerPhone: String,
  deliveryAddress: String,
  note: String,
  items: [mongoose.Schema.Types.Mixed],
  subtotal: { type: Number, required: true },
  discount: { type: Number, default: 0 },
  shippingFee: { type: Number, default: 0 },
  finalTotal: { type: Number, required: true },
  paymentMethod: { type: String, default: 'CASH' },
  paymentStatus: { type: String, default: 'UNPAID' },
  status: { type: String, default: 'PENDING' },
  statusTimeline: [{ status: String, time: Date }],
  voucherCode: String,
  needCorporateInvoice: { type: Boolean, default: false },
  corporateInvoiceInfo: mongoose.Schema.Types.Mixed,
  paymentTransactionId: String,
}, { timestamps: true });

orderSchema.pre('validate', function(next) {
  if (!this.orderNumber) this.orderNumber = `#${String(Date.now()).slice(-8)}`;
  next();
});

module.exports = mongoose.model('Order', orderSchema);
