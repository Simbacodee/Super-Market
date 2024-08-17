using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
using System.Data.Entity;
namespace SUPERMARKET.Controllers
{
    public class CheckOutController : Controller
    {
        // GET: CheckOut
        [HttpGet]
        public ActionResult Index()
        {
            KhachHang x = new KhachHang();
            CartShop gh = Session["GioHang"] as CartShop;
            ViewData["Cart"] = gh;
            return View(x);
        }
        [HttpPost]
        public ActionResult SaveToDataBase(KhachHang x)
        {
            using (var context = new SieuThiConnect())
            {
                using (DbContextTransaction trans = context.Database.BeginTransaction())
                {
                    try
                    {
                        x.maKH = x.soDT;
                        context.KhachHangs.Add(x);
                        context.SaveChanges();
                        DonHang d = new DonHang();
                        d.soDH = string.Format("{0:yyMMddhhmm}", DateTime.Now);
                        d.maKH = x.maKH;
                        d.ngayDat = DateTime.Now;
                        d.ngayGH = DateTime.Now.AddDays(2);
                        d.taiKhoan = "admin";
                        d.diaChiGH = x.diaChi;
                        context.DonHangs.Add(d);
                        context.SaveChanges();
                        CartShop gh = Session["GioHang"] as CartShop;
                        foreach (CtDonHang i in gh.SanPhamDC.Values)
                        {
                            i.soDH = d.soDH;
                            context.CtDonHangs.Add(i);
                        }

                        context.SaveChanges();
                        trans.Commit();
                        return RedirectToAction("Index", "CheckOutSuccess");
                    }
                    catch (Exception e)
                    {
                        trans.Rollback();
                    }
                }
            }
            return RedirectToAction("Index", "CheckOut");
        }
    }
}