using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SUPERMARKET.Models;
using PagedList;
using PagedList.Mvc;
namespace SUPERMARKET.Controllers
{
    public class ContentController : Controller
    {
        // GET: Content
        SieuThiConnect obj = new SieuThiConnect();


        public ActionResult Index(int ID)
        {
            var listSP = obj.SanPhams.Where(n => n.maDS == ID).ToList();
            ViewBag.c = listSP;
            return View();
        }
    }
}