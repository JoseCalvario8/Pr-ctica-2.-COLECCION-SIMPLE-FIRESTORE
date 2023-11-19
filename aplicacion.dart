import 'package:dam_u3_practica2/serviciosremotos.dart';
import 'package:flutter/material.dart';

class AppP2 extends StatefulWidget {
  const AppP2({super.key});

  @override
  State<AppP2> createState() => _AppP2State();
}

class _AppP2State extends State<AppP2> {
  //-------------VARIABLES--------------------
  int _index = 0;
  final nombre = TextEditingController();
  final edad = TextEditingController();
  final peso = TextEditingController();
  final altura = TextEditingController();
  final fechaCita = TextEditingController();
  Map<String, dynamic> datoJSON = {};
  final nombre2 = TextEditingController();
  final edad2 = TextEditingController();
  final peso2 = TextEditingController();
  final altura2 = TextEditingController();
  final fechaCita2 = TextEditingController();
  String idaux = "";
  String mensaje = "";
  final altura3 = TextEditingController();
  final peso3 = TextEditingController();
  //-------------VARIABLES---------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PRACTICA 2"),
        centerTitle: true,
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(child: Text("DC"),),
                SizedBox(height: 20,),
                Text("Dr. Lauro Martinez", style: TextStyle(color: Colors.white, fontSize: 20),)
              ],
            ),
                decoration: BoxDecoration(color: Colors.indigo),
            ),
            _item(Icons.add, "Insertar pacientes",1),
            _item(Icons.format_list_bulleted, "Citas", 0),
            _item(Icons.calculate_outlined, "Calculadora IMC",2),
          ],
        ),
      ),
    );
  }

 Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [Expanded(child: Icon(icono)), Expanded(child: Text(texto), flex: 2,)],
      ),
    );
 }
 Widget dinamico(){
    if(_index==1){
      return capturar();
    }
    if(_index==2){
      return pesoideal();
    }
    return cargarData();
 }

  Widget cargarData(){
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON){
          if(listaJSON.hasData){
            List<dynamic>? ordenada = listaJSON.data;
            ordenada?.sort((a, b) {
              DateTime fechaA = DateTime.parse(a['fechaCita']);
              DateTime fechaB = DateTime.parse(b['fechaCita']);
              return fechaA.compareTo(fechaB);
            });
            return ListView.builder(
                itemCount: ordenada?.length,
                itemBuilder: (context, indice){
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text("${ordenada?[indice]['nombre']}"),
                      subtitle: Text("Peso: ${ordenada?[indice]['peso']}, Altura: ${ordenada?[indice]['altura']} \nFecha: ${ordenada?[indice]['fechaCita']}"),
                      leading: Text("${indice + 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(Icons.error),
                                    SizedBox(width: 8,),
                                    Text("¡CUIDADO!")
                                  ],
                                ),
                                content: Text("¿Estás seguro que deseas eliminar el registro?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      DB.eliminar(ordenada?[indice]['id']).then((value) {
                                        setState(() {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SE ELIMINO CORRECTAMENTE.")));
                                        });
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Si"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      onTap: () {
                        setState(() {
                          idaux = listaJSON.data?[indice]['id'];
                          nombre2.text = listaJSON.data?[indice]['nombre'];
                          edad2.text = listaJSON.data![indice]['edad'].toString();
                          peso2.text = listaJSON.data![indice]['peso'].toString();
                          altura2.text = listaJSON.data![indice]['altura'].toString();
                          fechaCita2.text = listaJSON.data?[indice]['fechaCita'];
                          actualizar();
                        });
                      },
                    ),
                  );

                }
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

  Widget capturar(){
    return ListView(
      padding: EdgeInsets.all(30),
      children: [
        Center(
          child: Text("DATOS DEL PACIENTE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre",
              icon: Icon(Icons.person)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: edad,
          decoration: InputDecoration(
              labelText: "Edad:",
            icon: Icon(Icons.onetwothree)
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: peso,
          decoration: InputDecoration(
              labelText: "Peso:",
            icon: Icon(Icons.monitor_weight_outlined)
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: altura,
          decoration: InputDecoration(
              labelText: "Altura (en metros):",
            icon: Icon(Icons.height)
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: fechaCita,
          decoration: InputDecoration(
              labelText: "Fecha de cita:",
            icon: Icon(Icons.calendar_month)
          ),
          readOnly: true,
          onTap: (){
            _selectDate(fechaCita);
          },
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  var JSonTemporal = {
                    'nombre': nombre.text,
                    'edad': int.parse(edad.text),
                    'peso': double.parse(peso.text),
                    'altura': double.parse(altura.text),
                    'fechaCita': fechaCita.text
                  };
                  DB.insertar(JSonTemporal).then((value){
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SE INSERTO CORRECTAMENTE.")));
                    });
                  });
                  nombre.text = "";
                  edad.text = "";
                  peso.text = "";
                  altura.text = "";
                  fechaCita.text = "";
                },
                child: Text("Insertar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancel")
            ),
          ],
        )
      ],
    );
  }

  Widget pesoideal(){
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: altura3,
          decoration: InputDecoration(
              labelText: "Ingresa tu estatura (en metros):",
              border: OutlineInputBorder()
          ),
        ),
        SizedBox(height: 20,),
        TextField(
          controller: peso3,
          decoration: InputDecoration(
              labelText: "Ingresa tu peso (en KG):",
              border: OutlineInputBorder()
          ),
        ),
        SizedBox(height: 20,),
        ElevatedButton(
            onPressed: (){
              setState(() {
                double valor = double.parse(altura3.text);
                double valor2 = double.parse(peso3.text);
                double resultado = 0;

                resultado = valor2/(valor*valor);
                resultado = double.parse(resultado.toStringAsFixed(2));
                if(resultado<18.5){
                  mensaje = "Su indice de masa corporal es de: ${resultado}, por lo tanto usted tiene bajo peso";
                }
                if(resultado>=18.5 && resultado<=24.9){
                  mensaje = "Su indice de masa corporal es de: ${resultado}, por lo tanto usted esta en su peso normal";
                }
                if(resultado>=25.0 && resultado<=29.9){
                  mensaje = "Su indice de masa corporal es de: ${resultado}, por lo tanto usted tiene sobrepeso";
                }
                if(resultado>=30.0){
                  mensaje = "Su indice de masa corporal es de: ${resultado}, por lo tanto usted tiene obesidad";
                }
              });
            },
            child: const Text("Calcular peso")
        ),
        SizedBox(height: 20,),
        Text(mensaje, style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        SizedBox(height: 25,),
        Text("Si su IMC es inferior a 18.5, está dentro de los valores correspondientes a delgadez o bajo peso.", style: TextStyle(fontSize: 15),),
        SizedBox(height: 12,),
        Text("Si su IMC es entre 18.5 y 24.9, está dentro de los valores normales o de peso saludable.", style: TextStyle(fontSize: 15),),
        SizedBox(height: 12,),
        Text("Si su IMC es entre 25.0 y 29.9, está dentro de los valores correspondientes a sobrepeso.", style: TextStyle(fontSize: 15),),
        SizedBox(height: 12,),
        Text("Si su IMC es 30.0 o superior, está dentro de los valores de obesidad.", style: TextStyle(fontSize: 15),),
      ],
    );
  }

  void actualizar(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder){
          return Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom+40
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre2,
                  decoration: InputDecoration(
                      labelText: "Nombre"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: edad2,
                  decoration: InputDecoration(
                      labelText: "Edad:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: peso2,
                  decoration: InputDecoration(
                      labelText: "Peso:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: altura2,
                  decoration: InputDecoration(
                      labelText: "Altura:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: fechaCita2,
                  decoration: InputDecoration(
                      labelText: "Fecha cita:"),
                  readOnly: true,
                  onTap: (){
                    _selectDate(fechaCita2);
                  },
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          var JSonTemporal = {
                            'id': idaux,
                            'nombre': nombre2.text,
                            'edad': int.parse(edad2.text),
                            'peso': double.parse(peso2.text),
                            'altura': double.parse(altura2.text),
                            'fechaCita': fechaCita2.text,
                          };
                          DB.actualizar(JSonTemporal).then((value) {
                            setState(() {
                              _index = 0;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SE ACTUALIZO CORRECTAMENTE.")));
                            });
                          });
                          idaux = "";
                          nombre2.text = "";
                          edad2.text = "";
                          peso2.text = "";
                          altura2.text = "";
                          fechaCita2.text = "";
                          Navigator.pop(context);
                        },
                        child: Text("Actualizar")
                    ),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _index = 0;
                          });
                          Navigator.pop(context);
                          nombre2.text = "";
                          edad2.text = "";
                          peso2.text = "";
                          altura2.text = "";
                          fechaCita2.text = "";
                        },
                        child: Text("Cancel")
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  Future<void> _selectDate(TextEditingController controlador) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );

    if(_picked != null){
      setState(() {
        controlador.text = _picked.toString().split(" ")[0];
      });
    }
  }

}

