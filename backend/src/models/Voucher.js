const mongoose = require('mongoose');

const voucherSchema = new mongoose.Schema({
  code: { type: String, unique: true, uppercase: true, trim: true },
  title: String,
  discountPercent: { type: Number, default: 0 },
  discountAmount: { type: Number, default: 0 },
  maxDiscount: { type: Number, default: 0 },
  minOrderTotal: { type: Number, default: 0 },
  startDate: Date,
  endDate: Date,
  isActive: { type: Boolean, default: true },
}, { timestamps: true });

module.exports = mongoose.model('Voucher', voucherSchema);
