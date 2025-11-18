using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnPrueba_Click(object sender, EventArgs e)
        {

        }

        protected void btnIndex_Click(object sender, EventArgs e)
        {

        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Cache.Remove("datosUsuario");
            Cache.Remove("numPropiedadSeleccionada");
            Response.Redirect("Login.aspx");
        }
    }
}