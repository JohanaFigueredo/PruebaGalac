using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Windows.Forms;

namespace PruebaGalac
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btn_LeerArchivo_Click(object sender, EventArgs e)
        {
            try
            {
                LeerArvhivo();


            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.Message);
                RegistrarEvento(0, " Error", "E", "Error: " + ex.Message.ToString());
            }
            finally
            {
                
            }
        }//fin btn

        public void LeerArvhivo()
        {
            try
            {
                //variables
                string PalabraconS = "";
                string Palabrafinal = "";
                string PalabrasLinea = "";
                int contador = 0;
                //rutas de archivos de entrada y salida
                string RUTA = ConfigurationManager.AppSettings["RUTA_ARCHIVOS"].ToString();
                string ArchivoEntrada = ConfigurationManager.AppSettings["NOMBRE_ARCHIVO_ENTRADA"].ToString();
                string ArchivoSalida = ConfigurationManager.AppSettings["NOMBRE_ARCHIVO_SALIDA"].ToString(); ;

                StreamReader Archivo = new StreamReader(RUTA + ArchivoEntrada);

                //leo la primera linea
                string linea = Archivo.ReadLine();
                //recorro el archivo entrada hasta el final
                while (linea != null)
                {   
                    //guardo la linea
                    contador++;

                    //rrecorro la linea palabra por palabra
                    List<string> list = new List<string>();
                    list = linea.Split(' ').ToList();

                    foreach (string palabra in list)
                    {
                        //evaluo sila palabra contiene la letra S
                        bool esta = palabra.ToUpper().Contains("S");
                        if (esta)
                        {
                            Palabrafinal = palabra;
                            //elimino los caracteres especiales . ? , !
                            string[] charsToRemove = new string[] { "?", ",", ".", "!", "'" };
                            foreach (var c in charsToRemove)
                            {
                                Palabrafinal = Palabrafinal.Replace(c, string.Empty);
                            }
                            if (contador == 1)
                                PalabraconS = Palabrafinal;
                            else
                                PalabraconS = PalabraconS + ";" + Palabrafinal;
                            
                            PalabrasLinea = PalabrasLinea + "," + Palabrafinal;
                        }
                    }
                    //guardo las palabras encontradas en log de BD
                    RegistrarEvento(contador, PalabrasLinea, "I", "Palabras encontradas con la letra S");
                    PalabrasLinea = "";

                    //paso a la linea siguiente
                    linea = Archivo.ReadLine();
                }
                //cierro el archivo
                Archivo.Close();
                File.WriteAllText(RUTA + ArchivoSalida, PalabraconS);

                //Guardo en el log de BD
                RegistrarEvento(0, " Informacion", "I", "Archivo " + ArchivoSalida +" leído exitosamente");

                //llamo a la funcion para cargar el datagrid con las palabras guaradadas en el dia de ejecucion
                Mostrar();
            }
            
            catch (Exception ex)
            {
                RegistrarEvento(0, " Error", "E", "Error: " + ex.Message.ToString());
             }
            finally
            {
                MessageBox.Show("Proceso finalizado");
                RegistrarEvento(0, " Informacion", "I", "Proceso finalizado.");
            }
        }//fin LeerArvhivo


        public DataSet  RegistrarEvento(int Linea, string PalabrasEncontradas, string TipoEvento, string DescripcionEvento)
        {
            SqlConnection oConnection = null;
            SqlCommand oCommand = null;
            SqlDataAdapter oAdapter = null;
            DataSet oVerify = new DataSet();
            string sParam = string.Empty;
            string sConnection = string.Empty;

            try
            {
                //me conecto a bd
                sConnection = ConfigurationManager.ConnectionStrings["CONECCION_BASE_DATOS"].ToString();
                oConnection = new SqlConnection(sConnection);
                oConnection.Open();

                //ejecuto sp para guardar registro en BD
                oCommand = new SqlCommand("SP_RegistrarEvento", oConnection);
                oCommand.CommandType = CommandType.StoredProcedure;
                oCommand.Parameters.AddWithValue("@Linea", Linea);
                oCommand.Parameters.AddWithValue("@PalabrasEncontradas", PalabrasEncontradas);
                oCommand.Parameters.AddWithValue("@idTipoEvento", TipoEvento);
                oCommand.Parameters.AddWithValue("@DescripcionEvento", DescripcionEvento);
                oAdapter = new SqlDataAdapter(oCommand);
                oAdapter.Fill(oVerify);
                return oVerify;
            }
            catch (Exception ex)
            {
                RegistrarEvento(0, "Error", "E", "Error en RegistrarEvento: " + ex.Message.ToString());
                throw new Exception(ex.Message, ex);
            }
            finally
            {
                if (oConnection != null)
                {
                    oConnection.Close();
                }
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
           
        }

        public DataSet Mostrar()
        {
            SqlConnection oConnection = null;
            SqlCommand oCommand = null;
            DataSet oVerify = new DataSet();
            SqlDataAdapter oAdapter = null;
            string sParam = string.Empty;
            string sConnection = string.Empty;

            try
            {   
                //me conecto a BD
                sConnection = ConfigurationManager.ConnectionStrings["CONECCION_BASE_DATOS"].ToString();
                oConnection = new SqlConnection(sConnection);
                oConnection.Open();

                oCommand = new SqlCommand("SP_MostrarReg", oConnection);
                oCommand.CommandType = CommandType.StoredProcedure;

                oAdapter = new SqlDataAdapter(oCommand);
                oAdapter.Fill(oVerify);

                //lleno DGV
                dataGridView1.AutoGenerateColumns = true;
                dataGridView1.DataSource = oVerify.Tables[0];
                dataGridView1.Visible = true;

                RegistrarEvento(0, " Informacion", "I", "Se ejecuto la funcion Mostrar");

                return oVerify;
            }
            catch (Exception ex)
            {
                RegistrarEvento(0, " Error", "E", "Error en Mostrar: " + ex.Message.ToString());
                throw new Exception(ex.Message, ex);
            }
            finally
            {
                if (oConnection != null)
                {
                    oConnection.Close();
                }
            }
        }

    }
}
