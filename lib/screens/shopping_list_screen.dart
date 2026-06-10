import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ShoppingListScreen extends StatefulWidget {

  final Color themeColor;
  final String type;


  const ShoppingListScreen({
    super.key,
    required this.themeColor,
    required this.type,
  });


  @override
  State<ShoppingListScreen> createState()
  => _ShoppingListScreenState();

}





class _ShoppingListScreenState
    extends State<ShoppingListScreen> {


  final TextEditingController _controller =
  TextEditingController();


  final List<String> items = [];




  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
    double? height,
  }){

    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );

  }






  void addItem(){


    if(_controller.text.trim().isEmpty){
      return;
    }


    setState(() {

      items.add(
        _controller.text.trim(),
      );

      _controller.clear();

    });


  }







  @override
  Widget build(BuildContext context){


    return AnnotatedRegion<SystemUiOverlayStyle>(


      value: const SystemUiOverlayStyle(

        statusBarColor:
        Colors.transparent,

        statusBarIconBrightness:
        Brightness.dark,

      ),



      child: Scaffold(

        backgroundColor:
        const Color(0xFFFAFAFC),




        appBar: AppBar(

          backgroundColor:
          Colors.white,

          elevation: 0,

          centerTitle: true,


          leading: IconButton(

            icon: const Icon(

              Icons.arrow_back_ios_new_rounded,

              color:
              Color(0xFF111827),

              size: 20,

            ),


            onPressed: () =>
                Navigator.pop(context),

          ),



          title: Text(

            "${widget.type} List",

            style:
            _s(

              size: 18,

              weight:
              FontWeight.w700,

            ),

          ),


        ),






        body: SingleChildScrollView(

          physics:
          const BouncingScrollPhysics(),

          padding:
          const EdgeInsets.all(20),




          child: Column(

            children: [






              // HEADER


              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(26),



                decoration:
                BoxDecoration(


                  gradient:
                  LinearGradient(

                    colors: [

                      widget.themeColor,

                      widget.themeColor
                      .withOpacity(0.75),

                    ],

                  ),



                  borderRadius:
                  BorderRadius.circular(26),



                  boxShadow: [

                    BoxShadow(

                      color:
                      widget.themeColor
                      .withOpacity(0.3),

                      blurRadius: 20,

                      offset:
                      const Offset(0,8),

                    ),

                  ],

                ),




                child: Column(

                  children: [


                    Icon(

                      widget.type=="Medical"
                      ? Icons.medical_services_rounded
                      : Icons.shopping_basket_rounded,


                      color:
                      Colors.white,


                      size: 50,

                    ),



                    const SizedBox(height: 14),




                    Text(

                      "My ${widget.type} List",

                      style:
                      _s(

                        size: 26,

                        weight:
                        FontWeight.w800,

                        color:
                        Colors.white,

                      ),

                    ),




                    const SizedBox(height: 8),



                    Text(

                      widget.type=="Medical"

                      ? "Create your medicine list and never forget essentials"

                      : "Create your shopping list before ordering",


                      textAlign:
                      TextAlign.center,

                      style:
                      _s(

                        size: 13,

                        color:
                        Colors.white70,

                      ),

                    ),


                  ],

                ),

              ),








              const SizedBox(height: 28),







              // INPUT


              Row(

                children: [


                  Expanded(

                    child:
                    TextField(

                      controller:
                      _controller,


                      decoration:
                      InputDecoration(

                        hintText:

                        widget.type=="Medical"

                        ? "Enter medicine name"

                        : "Enter item name",



                        filled: true,


                        fillColor:
                        Colors.white,



                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(18),

                          borderSide:
                          BorderSide.none,

                        ),


                      ),

                    ),

                  ),



                  const SizedBox(width: 12),




                  GestureDetector(

                    onTap:
                    addItem,


                    child:
                    Container(

                      padding:
                      const EdgeInsets.all(15),


                      decoration:
                      BoxDecoration(

                        color:
                        widget.themeColor,


                        shape:
                        BoxShape.circle,

                      ),



                      child:
                      const Icon(

                        Icons.add,

                        color:
                        Colors.white,

                      ),

                    ),

                  )


                ],

              ),








              const SizedBox(height: 25),







              items.isEmpty



              ? Padding(

                padding:
                const EdgeInsets.only(top:40),

                child:
                Text(

                  "Your list is empty",

                  style:
                  _s(

                    color:
                    const Color(0xFF9CA3AF),

                  ),

                ),

              )




              : ListView.builder(

                shrinkWrap: true,

                physics:
                const NeverScrollableScrollPhysics(),


                itemCount:
                items.length,


                itemBuilder:
                (context,index){


                  return Container(

                    margin:
                    const EdgeInsets.only(bottom:12),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,


                      borderRadius:
                      BorderRadius.circular(18),

                    ),



                    child:
                    ListTile(


                      leading:
                      Icon(

                        Icons.check_circle,

                        color:
                        widget.themeColor,

                      ),



                      title:
                      Text(

                        items[index],

                        style:
                        _s(

                          weight:
                          FontWeight.w600,

                        ),

                      ),



                      trailing:
                      IconButton(

                        icon:
                        const Icon(

                          Icons.delete_outline,

                          color:
                          Colors.red,

                        ),


                        onPressed: (){

                          setState(() {

                            items.removeAt(index);

                          });

                        },

                      ),


                    ),

                  );


                },

              ),







              const SizedBox(height:30),







              Row(

                children: [


                  Expanded(

                    child:
                    OutlinedButton.icon(

                      onPressed: () {},

                      icon:
                      Icon(

                        Icons.save_outlined,

                        color:
                        widget.themeColor,

                      ),

                      label:
                      Text(

                        "Save List",

                        style:
                        TextStyle(

                          color:
                          widget.themeColor,

                        ),

                      ),

                    ),

                  ),




                  const SizedBox(width:12),





                  Expanded(

                    child:
                    ElevatedButton.icon(

                      onPressed: () {},


                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        widget.themeColor,

                      ),



                      icon:
                      const Icon(

                        Icons.share,

                        color:
                        Colors.white,

                      ),



                      label:
                      const Text(

                        "Share",

                        style:
                        TextStyle(

                          color:
                          Colors.white,

                        ),

                      ),


                    ),

                  ),


                ],

              ),





            ],

          ),

        ),

      ),

    );


  }

}