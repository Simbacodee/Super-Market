using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
using PagedList;
using PagedList.Mvc;
using System.IO;

namespace SUPERMARKET.Areas.PrivatePage.Controllers
{
    public class ProductController : Controller
    {
        private SieuThiConnect db = new SieuThiConnect();

        // GET: PrivatePage/Product

        public ActionResult Index(int? page)
        {
            int pageNumber = (page ?? 1);
            int pageSize = 7;
            var list = db.SanPhams;
            return View(list.ToList().OrderBy(n => n.maLoai).ToPagedList(pageNumber, pageSize));
        }

        // GET: PrivatePage/Product/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            return View(sanPham);
        }

        // GET: PrivatePage/Product/Create
        public ActionResult Create()
        {
            ViewBag.maDS = new SelectList(db.DScons, "maDS", "tenDS");
            ViewBag.maLoai = new SelectList(db.LoaiSPs, "maLoai", "tenLoai");
            ViewBag.maNH = new SelectList(db.nhanHangs, "maNH", "tenNH");
            ViewBag.taiKhoan = new SelectList(db.TaiKhoans, "taiKhoan1", "matKhau");
            return View();
        }

        // POST: PrivatePage/Product/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "maSP,tenSP,hinhDD,ndTomTat,ngayDang,maLoai,maDS,maNH,noiDung,taiKhoan,dvt,daDuyet,giaBan,giamGia,nhaSanXuat")] SanPham sanPham)
        {
            if (ModelState.IsValid)
            {
                db.SanPhams.Add(sanPham);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.maDS = new SelectList(db.DScons, "maDS", "tenDS", sanPham.maDS);
            ViewBag.maLoai = new SelectList(db.LoaiSPs, "maLoai", "tenLoai", sanPham.maLoai);
            ViewBag.maNH = new SelectList(db.nhanHangs, "maNH", "tenNH", sanPham.maNH);
            ViewBag.taiKhoan = new SelectList(db.TaiKhoans, "taiKhoan1", "matKhau", sanPham.taiKhoan);
            return View(sanPham);
        }

        // GET: PrivatePage/Product/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            ViewBag.maDS = new SelectList(db.DScons, "maDS", "tenDS", sanPham.maDS);
            ViewBag.maLoai = new SelectList(db.LoaiSPs, "maLoai", "tenLoai", sanPham.maLoai);
            ViewBag.maNH = new SelectList(db.nhanHangs, "maNH", "tenNH", sanPham.maNH);
            ViewBag.taiKhoan = new SelectList(db.TaiKhoans, "taiKhoan1", "matKhau", sanPham.taiKhoan);
            return View(sanPham);
        }

        // POST: PrivatePage/Product/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "maSP,tenSP,hinhDD,ndTomTat,ngayDang,maLoai,maDS,maNH,noiDung,taiKhoan,dvt,daDuyet,giaBan,giamGia,nhaSanXuat")] SanPham sanPham)
        {
            if (ModelState.IsValid)
            {
                db.Entry(sanPham).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.maDS = new SelectList(db.DScons, "maDS", "tenDS", sanPham.maDS);
            ViewBag.maLoai = new SelectList(db.LoaiSPs, "maLoai", "tenLoai", sanPham.maLoai);
            ViewBag.maNH = new SelectList(db.nhanHangs, "maNH", "tenNH", sanPham.maNH);
            ViewBag.taiKhoan = new SelectList(db.TaiKhoans, "taiKhoan1", "matKhau", sanPham.taiKhoan);
            return View(sanPham);
        }

        // GET: PrivatePage/Product/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            return View(sanPham);
        }

        // POST: PrivatePage/Product/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            SanPham sanPham = db.SanPhams.Find(id);
            db.SanPhams.Remove(sanPham);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}