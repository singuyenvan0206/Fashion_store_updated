namespace WpfApp1
{
    public class Voucher
    {
        public int Id { get; set; }
        public string Code { get; set; } = string.Empty;
        public string DiscountType { get; set; } = "VND"; // "VND" or "%"
        public decimal DiscountValue { get; set; }
        public decimal MinInvoiceAmount { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int UsageLimit { get; set; }
        public int UsedCount { get; set; }
        public bool IsActive { get; set; } = true;

        public bool IsValid()
        {
            if (!IsActive) return false;
            var now = DateTime.Now;
            if (now < StartDate || now > EndDate) return false;
            if (UsageLimit > 0 && UsedCount >= UsageLimit) return false;
            return true;
        }
    }
}
