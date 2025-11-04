using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnEntrar_Click(object sender, EventArgs e)
        {
            String username = txtUsuario.Text;
            String password = txtContrasena.Text;
            if(username== ""  || password == "") { return; }

            var usuario = new
            {
                Nombre = username,
                Identificacion = password,
                IP = ipTextBox.Text
            };

            //Crear token
            string token = Guid.NewGuid().ToString();         
            Cache.Insert(token, usuario, null, DateTime.Now.AddMinutes(28), TimeSpan.Zero);
            
            Response.Redirect("Index.aspx?token=" + token);

        }
    }
}