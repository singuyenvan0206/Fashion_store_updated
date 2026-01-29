using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Media;

namespace WpfApp1
{
    public partial class VoucherManagementWindow : Window
    {
        private List<Voucher> _vouchers = new();

        public VoucherManagementWindow()
        {
            InitializeComponent();
            LoadVouchers();
            StartDatePicker.SelectedDate = DateTime.Today;
            EndDatePicker.SelectedDate = DateTime.Today.AddDays(30);
        }

        private void LoadVouchers()
        {
            _vouchers = DatabaseHelper.GetAllVouchers();
            VouchersListBox.ItemsSource = null;
            VouchersListBox.ItemsSource = _vouchers;
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            if (!ValidateInput()) return;

            var voucher = new Voucher
            {
                Code = CodeTextBox.Text.Trim().ToUpper(),
                DiscountType = (DiscountTypeComboBox.SelectedIndex == 1) ? "%" : "VND",
                DiscountValue = decimal.Parse(DiscountValueTextBox.Text),
                MinInvoiceAmount = decimal.Parse(MinInvoiceTextBox.Text),
                StartDate = StartDatePicker.SelectedDate ?? DateTime.Today,
                EndDate = EndDatePicker.SelectedDate ?? DateTime.Today,
                UsageLimit = int.Parse(UsageLimitTextBox.Text),
                IsActive = IsActiveCheckBox.IsChecked ?? true
            };

            if (DatabaseHelper.AddVoucher(voucher))
            {
                MessageBox.Show("Thêm Voucher thành công!", "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                LoadVouchers();
                ClearForm();
            }
            else
            {
                MessageBox.Show("Có lỗi xảy ra. Mã voucher có thể đã tồn tại.", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void UpdateButton_Click(object sender, RoutedEventArgs e)
        {
            if (VouchersListBox.SelectedItem is not Voucher selected)
            {
                MessageBox.Show("Vui lòng chọn voucher cần sửa.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!ValidateInput()) return;

            selected.Code = CodeTextBox.Text.Trim().ToUpper();
            selected.DiscountType = (DiscountTypeComboBox.SelectedIndex == 1) ? "%" : "VND";
            selected.DiscountValue = decimal.Parse(DiscountValueTextBox.Text);
            selected.MinInvoiceAmount = decimal.Parse(MinInvoiceTextBox.Text);
            selected.StartDate = StartDatePicker.SelectedDate ?? DateTime.Today;
            selected.EndDate = EndDatePicker.SelectedDate ?? DateTime.Today;
            selected.UsageLimit = int.Parse(UsageLimitTextBox.Text);
            selected.IsActive = IsActiveCheckBox.IsChecked ?? true;

            if (DatabaseHelper.UpdateVoucher(selected))
            {
                MessageBox.Show("Cập nhật Voucher thành công!", "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                LoadVouchers();
                ClearForm();
            }
            else
            {
                MessageBox.Show("Có lỗi xảy ra khi cập nhật.", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (VouchersListBox.SelectedItem is not Voucher selected)
            {
                MessageBox.Show("Vui lòng chọn voucher cần xóa.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var result = MessageBox.Show($"Bạn có chắc chắn muốn xóa '{selected.Code}'?", "Xác nhận", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                if (DatabaseHelper.DeleteVoucher(selected.Id))
                {
                    MessageBox.Show("Xóa Voucher thành công!", "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                    LoadVouchers();
                    ClearForm();
                }
                else
                {
                    MessageBox.Show("Không thể xóa voucher này.", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void ClearButton_Click(object sender, RoutedEventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            CodeTextBox.Clear();
            DiscountValueTextBox.Clear();
            MinInvoiceTextBox.Text = "0";
            UsageLimitTextBox.Text = "0";
            StartDatePicker.SelectedDate = DateTime.Today;
            EndDatePicker.SelectedDate = DateTime.Today.AddDays(30);
            IsActiveCheckBox.IsChecked = true;
            DiscountTypeComboBox.SelectedIndex = 0;
            VouchersListBox.SelectedItem = null;
        }

        private bool ValidateInput()
        {
            if (string.IsNullOrWhiteSpace(CodeTextBox.Text))
            {
                MessageBox.Show("Mã Voucher không được để trống.", "Lỗi nhập liệu", MessageBoxButton.OK, MessageBoxImage.Warning);
                CodeTextBox.Focus();
                return false;
            }
            if (!decimal.TryParse(DiscountValueTextBox.Text, out var val) || val < 0)
            {
                MessageBox.Show("Giá trị giảm giá không hợp lệ.", "Lỗi nhập liệu", MessageBoxButton.OK, MessageBoxImage.Warning);
                DiscountValueTextBox.Focus();
                return false;
            }
            if (!decimal.TryParse(MinInvoiceTextBox.Text, out var min) || min < 0)
            {
                MessageBox.Show("Hóa đơn tối thiểu không hợp lệ.", "Lỗi nhập liệu", MessageBoxButton.OK, MessageBoxImage.Warning);
                MinInvoiceTextBox.Focus();
                return false;
            }
            if (!int.TryParse(UsageLimitTextBox.Text, out var limit) || limit < 0)
            {
                MessageBox.Show("Giới hạn sử dụng không hợp lệ.", "Lỗi nhập liệu", MessageBoxButton.OK, MessageBoxImage.Warning);
                UsageLimitTextBox.Focus();
                return false;
            }
            if (StartDatePicker.SelectedDate == null || EndDatePicker.SelectedDate == null)
            {
                MessageBox.Show("Vui lòng chọn ngày bắt đầu và kết thúc.", "Lỗi nhập liệu", MessageBoxButton.OK, MessageBoxImage.Warning);
                return false;
            }
            if (StartDatePicker.SelectedDate > EndDatePicker.SelectedDate)
            {
                MessageBox.Show("Ngày bắt đầu không được sau ngày kết thúc.", "Lỗi nhập liệu", MessageBoxButton.OK, MessageBoxImage.Warning);
                return false;
            }
            return true;
        }

        private void VouchersListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (VouchersListBox.SelectedItem is Voucher selected)
            {
                CodeTextBox.Text = selected.Code;
                DiscountTypeComboBox.SelectedIndex = selected.DiscountType == "%" ? 1 : 0;
                DiscountValueTextBox.Text = selected.DiscountValue.ToString("F0"); // Assuming integer based inputs mostly
                MinInvoiceTextBox.Text = selected.MinInvoiceAmount.ToString("F0");
                StartDatePicker.SelectedDate = selected.StartDate;
                EndDatePicker.SelectedDate = selected.EndDate;
                UsageLimitTextBox.Text = selected.UsageLimit.ToString();
                IsActiveCheckBox.IsChecked = selected.IsActive;
            }
        }
    }

    public class BooleanToStatusColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return (bool)value ? new SolidColorBrush(Color.FromRgb(76, 175, 80)) : new SolidColorBrush(Color.FromRgb(158, 158, 158));
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

    public class BooleanToStatusTextConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return (bool)value ? "Active" : "Inactive";
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
