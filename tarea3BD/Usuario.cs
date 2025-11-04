using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace tarea3BD
{
    public class Usuario
    {
        public String nombre { get; set; }
        public String password { get; set; }
        public String IP { get; set; }
        public String rol { get; set; }

        public Usuario(String nombre, String password, String IP)
        {
            this.nombre = nombre;
            this.password = password;
            this.IP = IP;
        }
    }
}