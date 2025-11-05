using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tarea3BD
{
    public partial class Index : System.Web.UI.Page
    {
        Usuario usuiario;
        protected void Page_Load(object sender, EventArgs e)
        {

                var datos = Cache["datosUsuario"];
                if (datos != null)
                {
                    dynamic usuario = datos;
                    Response.Write($"Usuario: {usuario.Nombre}, IP: {usuario.IP}");
                }
                cargarDatosPropiedadesGV();
                cambioEstadoBtn(false);
                listaFacturas.Enabled = false;
                btnPag.Enabled = false;
            
        }

        protected void propiedadesGVRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Ver")
            {
                cambioEstadoBtn(true);
                //indice de la fila
                int index = Convert.ToInt32(e.CommandArgument);
                //Obtener la fila seleccionada
                GridViewRow row = propiedadesGV.Rows[index];

                string numPropiedad = row.Cells[0].Text;
                string nombrePropietario = row.Cells[1].Text;
                Cache.Insert("numPropiedadSeleccionada", numPropiedad, null, DateTime.Now.AddMinutes(28), TimeSpan.Zero);
                //Verificar que funciona
                Response.Write($"Clic en '{numPropiedad}' (nombre: {nombrePropietario})");

            }
        }
        protected void cargarDatosPropiedadesGV()
        {
            //Para probar el GV
            //Aquí se cargarian los datos desde la BD
            List <Propiedad>listaPropiedades = new List<Propiedad>()
            {
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915),
                new Propiedad("Juan Alberto", 5431),
                new Propiedad("Ana Valeria", 737915)
            };
            var listaOrdenada = listaPropiedades.OrderBy(x => x.nombrePropietario).ToList();
            propiedadesGV.DataSource = listaOrdenada;
            propiedadesGV.DataBind();
        }

        public void cambioEstadoBtn(bool estado)
        {
            btnFacPag.Enabled = estado;
            btnFacPen.Enabled = estado;
            btnPagFac.Enabled = estado;            
        }

        protected void btnPagFac_Click(object sender, EventArgs e)
        {
            listaFacturas.Enabled = true;
            btnPag.Enabled = true;
            var datos = Cache["numPropiedadSeleccionada"];
            Response.Write($"Propiedad seleccionada: {datos}");
        }
    }
}