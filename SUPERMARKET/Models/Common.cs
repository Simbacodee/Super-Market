using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace SUPERMARKET.Models
{
    public class Common
    {
        static DbContext cn = new DbContext("name=SieuThiConnect");
        /// <summary>
        /// Hàm lấy ra danh sách các sản phẩm đang kinh doanh
        /// </summary>
        /// <returns></returns>
        public static List<SanPham> getProduct()
        {
            List<SanPham> l = new List<SanPham>();
            //Khai bao 1 doi tuong dai dien cho database
            DbContext cn = new DbContext("name=SieuThiConnect");
            //Lay du lieu
            l = cn.Set<SanPham>().ToList<SanPham>();
            return l;
        }
        /// <summary>
        /// Hàm lấy ra các danh mục đang kinh doanh
        /// </summary>
        /// <returns></returns>
        public static List<LoaiSP> getCategories()
        {
            List<LoaiSP> a = new List<LoaiSP>();
            DbContext a1 = new DbContext("name=SieuThiConnect");
            
            return a;
        }
        /// <summary>
        /// Hàm lấy ra danh mục con 
        /// </summary>
        /// <returns></returns>
        public static List<DScon> getMiniCategories()
        {
            List<DScon> b = new List<DScon>();
            DbContext b1 = new DbContext("name=SieuThiConnect");
            b = b1.Set<DScon>().ToList<DScon>();
            return b;
        }
        public static SanPham GetProductById(string maSP)
        {
            return cn.Set<SanPham>().Find(maSP);
        }
        public static string getNameOfProDuctById(string maSP)
        {
            return cn.Set<SanPham>().Find(maSP).tenSP;
        }
        public static string getImageOfProDuctById(string maSP)
        {
            return cn.Set<SanPham>().Find(maSP).hinhDD;
        }
        public static List<KhachHang> getCustomer()
        {
            return new DbContext("name = SieuThiConnect").Set<KhachHang>().ToList<KhachHang>();
        }
        
    }
}