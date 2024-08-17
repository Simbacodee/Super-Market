using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
namespace SUPERMARKET.Areas.PrivatePage.Controllers
{

    public class CatagoriesController : Controller
    {
        private static bool isUpdate = false;
        // GET: PrivatePage/Catagories
        [HttpGet]
        public ActionResult Index()
        {
            List<LoaiSP> l = new SieuThiConnect().LoaiSPs.OrderBy(x => x.tenLoai).ToList<LoaiSP>();
            ViewData["DsLoai"] = l;
            return View();
        }
        [HttpPost]
        public ActionResult Index(LoaiSP x)
        {
            SieuThiConnect db = new SieuThiConnect();
            // them LoaiSP
            if (!isUpdate)
                db.LoaiSPs.Add(x);
            else
            {
                LoaiSP y = db.LoaiSPs.Find(x.maLoai);
                y.tenLoai = x.tenLoai;
                y.ghiChu = x.ghiChu;
                isUpdate = false;
            }

            db.SaveChanges(); // luu tren database
            //cap nhat list tren view
            if (ModelState.IsValid)
                ModelState.Clear();
            ViewData["DsLoai"] = db.LoaiSPs.OrderBy(z => z.tenLoai).ToList<LoaiSP>();
            return View();
        }
        [HttpPost]
        public ActionResult Delete(string maLoai)
        {
            SieuThiConnect db = new SieuThiConnect();
            int ma = int.Parse(maLoai);
            LoaiSP x = db.LoaiSPs.Find(ma);
            db.LoaiSPs.Remove(x);
            db.SaveChanges();
            ViewData["DsLoai"] = db.LoaiSPs.OrderBy(z => z.maLoai).ToList<LoaiSP>();
            return View("Index");
        }
        [HttpPost]
        public ActionResult Update(string mlcs)
        {
            SieuThiConnect db = new SieuThiConnect();
            int ma = int.Parse(mlcs);
            LoaiSP x = db.LoaiSPs.Find(ma);
            isUpdate = true;
            ViewData["DsLoai"] = db.LoaiSPs.OrderBy(z => z.maLoai).ToList<LoaiSP>();
            return View("Index", x);
        }
    }
}
