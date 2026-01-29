using System.IO;
using System.Text;
using Microsoft.Win32;
using System.Windows;
using System.Reflection;

namespace WpfApp1
{
    public static class ExportHelper
    {
        public static void ExportToCsv<T>(List<T> data, string defaultFileName)
        {
            try
            {
                var saveFileDialog = new SaveFileDialog
                {
                    Filter = "CSV File (*.csv)|*.csv",
                    FileName = defaultFileName
                };

                if (saveFileDialog.ShowDialog() == true)
                {
                    var sb = new StringBuilder();

                    // Get properties for header
                    var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
                    
                    // Write Header
                    for (int i = 0; i < properties.Length; i++)
                    {
                        sb.Append(EscapeCsv(properties[i].Name));
                        if (i < properties.Length - 1) sb.Append(",");
                    }
                    sb.AppendLine();

                    // Write Rows
                    foreach (var item in data)
                    {
                        for (int i = 0; i < properties.Length; i++)
                        {
                            var val = properties[i].GetValue(item);
                            var strVal = val == null ? "" : val.ToString();
                            
                            // Format dates specially if needed
                            if (val is DateTime dt)
                            {
                                strVal = dt.ToString("yyyy-MM-dd HH:mm:ss");
                            }

                            sb.Append(EscapeCsv(strVal));
                            if (i < properties.Length - 1) sb.Append(",");
                        }
                        sb.AppendLine();
                    }

                    // Write to file with UTF8 BOM for correct Excel display of special characters
                    File.WriteAllText(saveFileDialog.FileName, sb.ToString(), Encoding.UTF8);
                    
                    MessageBox.Show("Xuất file thành công!", "Thành công", MessageBoxButton.OK, MessageBoxImage.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi khi xuất file: {ex.Message}", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private static string EscapeCsv(string val)
        {
            if (val.Contains(",") || val.Contains("\"") || val.Contains("\n") || val.Contains("\r"))
            {
                return "\"" + val.Replace("\"", "\"\"") + "\"";
            }
            return val;
        }
    }
}
