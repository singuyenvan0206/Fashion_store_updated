using System.Windows;
using System.Windows.Controls;

namespace WpfApp1
{
    public partial class SupplierManagementWindow : Window
    {
        private List<Supplier> _suppliers = new();

        public SupplierManagementWindow()
        {
            InitializeComponent();
            LoadSuppliers();
        }

        private void LoadSuppliers()
        {
            _suppliers = DatabaseHelper.GetAllSuppliers();
            SuppliersListBox.ItemsSource = null;
            SuppliersListBox.ItemsSource = _suppliers;
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            if (!ValidateInput()) return;

            var supplier = new Supplier
            {
                Name = NameTextBox.Text.Trim(),
                ContactName = ContactTextBox.Text.Trim(),
                Phone = PhoneTextBox.Text.Trim(),
                Email = EmailTextBox.Text.Trim(),
                Address = AddressTextBox.Text.Trim(),
                Note = NoteTextBox.Text.Trim()
            };

            if (DatabaseHelper.AddSupplier(supplier))
            {
                MessageBox.Show("Thêm nhà cung cấp thành công!", "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                LoadSuppliers();
                ClearForm();
            }
            else
            {
                MessageBox.Show("Có lỗi xảy ra khi thêm nhà cung cấp.", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void UpdateButton_Click(object sender, RoutedEventArgs e)
        {
            if (SuppliersListBox.SelectedItem is not Supplier selectedSupplier)
            {
                MessageBox.Show("Vui lòng chọn nhà cung cấp cần sửa.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!ValidateInput()) return;

            selectedSupplier.Name = NameTextBox.Text.Trim();
            selectedSupplier.ContactName = ContactTextBox.Text.Trim();
            selectedSupplier.Phone = PhoneTextBox.Text.Trim();
            selectedSupplier.Email = EmailTextBox.Text.Trim();
            selectedSupplier.Address = AddressTextBox.Text.Trim();
            selectedSupplier.Note = NoteTextBox.Text.Trim();

            if (DatabaseHelper.UpdateSupplier(selectedSupplier))
            {
                MessageBox.Show("Cập nhật nhà cung cấp thành công!", "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                LoadSuppliers();
                ClearForm();
            }
            else
            {
                MessageBox.Show("Có lỗi xảy ra khi cập nhật.", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            if (SuppliersListBox.SelectedItem is not Supplier selectedSupplier)
            {
                MessageBox.Show("Vui lòng chọn nhà cung cấp cần xóa.", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var result = MessageBox.Show($"Bạn có chắc chắn muốn xóa '{selectedSupplier.Name}'?", "Xác nhận", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                if (DatabaseHelper.DeleteSupplier(selectedSupplier.Id))
                {
                    MessageBox.Show("Xóa nhà cung cấp thành công!", "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                    LoadSuppliers();
                    ClearForm();
                }
                else
                {
                    MessageBox.Show("Không thể xóa nhà cung cấp này.", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void ClearButton_Click(object sender, RoutedEventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            NameTextBox.Clear();
            ContactTextBox.Clear();
            PhoneTextBox.Clear();
            EmailTextBox.Clear();
            AddressTextBox.Clear();
            NoteTextBox.Clear();
            SuppliersListBox.SelectedItem = null;
        }

        private bool ValidateInput()
        {
            if (string.IsNullOrWhiteSpace(NameTextBox.Text))
            {
                MessageBox.Show("Tên nhà cung cấp không được để trống.", "Lỗi nhập liệu", MessageBoxButton.OK, MessageBoxImage.Warning);
                NameTextBox.Focus();
                return false;
            }
            return true;
        }

        private void SuppliersListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (SuppliersListBox.SelectedItem is Supplier selectedSupplier)
            {
                NameTextBox.Text = selectedSupplier.Name;
                ContactTextBox.Text = selectedSupplier.ContactName;
                PhoneTextBox.Text = selectedSupplier.Phone;
                EmailTextBox.Text = selectedSupplier.Email;
                AddressTextBox.Text = selectedSupplier.Address;
                NoteTextBox.Text = selectedSupplier.Note;
            }
        }
    }
}
