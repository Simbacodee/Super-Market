using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;
namespace SUPERMARKET.Models
{
    public class MaHoa
    {
        public static string encryptSHA256(string PlainText)
        {
            string result = "";
            using (SHA256 bb = SHA256.Create())
            {
                byte[] sourceData = Encoding.UTF8.GetBytes(PlainText);
                byte[] hash = bb.ComputeHash(sourceData);
                result = BitConverter.ToString(hash);
            }
            return result;
        }
    }
}