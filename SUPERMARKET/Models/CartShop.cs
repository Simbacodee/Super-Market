using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SUPERMARKET.Models
{
    public class CartShop
    {
        public string MaKH { get; set; }
        public string TaiKhoan { get; set; }
        public DateTime NgayDat { get; set; }
        public DateTime NgayGiao { get; set; }
        public string DiaChi { get; set; }
        public SortedList<string, CtDonHang> SanPhamDC { get; set; }
        public CartShop()
        {
            this.MaKH = "";
            this.TaiKhoan = "";
            this.NgayDat = DateTime.Now;
            this.NgayGiao = DateTime.Now.AddDays(2);
            this.DiaChi = "";
            this.SanPhamDC = new SortedList<string, CtDonHang>();
        }
        public bool IsEmpty()
        {
            return (SanPhamDC.Keys.Count == 0);
        }
        public void addItem(string maSP)
        {
            if (SanPhamDC.Keys.Contains(maSP))
            {
                CtDonHang x = SanPhamDC.Values[SanPhamDC.IndexOfKey(maSP)];
                x.soLuong++;

            }
            else
            {
                CtDonHang i = new CtDonHang();
                i.maSP = maSP;
                i.soLuong = 1;
                SanPham z = Common.GetProductById(maSP);
                i.giaBan = z.giaBan;
                i.giamGia = z.giamGia;
                SanPhamDC.Add(maSP, i);
            }
        }

        public void deleteItem(string maSP)
        {
            if (SanPhamDC.Keys.Contains(maSP))
            {
                SanPhamDC.Remove(maSP);
            }
        }
        public void decrease(string maSP)
        {
            if (SanPhamDC.Keys.Contains(maSP))
            {
                CtDonHang x = SanPhamDC.Values[SanPhamDC.IndexOfKey(maSP)];
                if (x.soLuong > 1)
                {
                    x.soLuong--;
                }
                else
                    deleteItem(maSP);
            }
        }
        public long moneyOfOneProduct(CtDonHang x)
        {
            return (long)(x.giaBan * x.soLuong);
        }
        public long totalOfCartShop()
        {
            long kq = 0;
            foreach (CtDonHang i in SanPhamDC.Values)
                kq += moneyOfOneProduct(i);
            return kq;
        }
    }
}