import 'package:flutter/material.dart';

import 'address_screen.dart';


class AddressesScreen extends StatefulWidget {

  final Color themeColor;


  const AddressesScreen({
    super.key,
    required this.themeColor,
  });


  @override
  State<AddressesScreen> createState()
  => _AddressesScreenState();

}




class _AddressesScreenState
    extends State<AddressesScreen> {



  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
  }){

    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );

  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xFFFAFAFC),




      appBar: AppBar(

        backgroundColor:
        Colors.white,


        elevation:0,

        centerTitle:true,


        leading:IconButton(

          icon:
          const Icon(

            Icons.arrow_back_ios_new_rounded,

            color:
            Color(0xFF111827),

            size:20,

          ),


          onPressed:()=>
          Navigator.pop(context),

        ),



        title:
        Text(

          "Saved Addresses",

          style:
          _s(

            size:18,

            weight:
            FontWeight.w700,

          ),

        ),

      ),







      body:

      globalSavedAddresses.isEmpty


      ? Center(

        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Icon(

              Icons.location_off_outlined,

              size:70,

              color:
              widget.themeColor.withOpacity(0.3),

            ),



            const SizedBox(height:14),



            Text(

              "No Address Saved",

              style:
              _s(

                size:18,

                weight:
                FontWeight.w700,

              ),

            ),



            const SizedBox(height:6),



            Text(

              "Your saved delivery addresses\nwill appear here",

              textAlign:
              TextAlign.center,

              style:
              _s(

                size:13,

                color:
                const Color(0xFF6B7280),

              ),

            ),

          ],

        ),

      )





      : ListView.builder(

        padding:
        const EdgeInsets.all(20),

        physics:
        const BouncingScrollPhysics(),


        itemCount:
        globalSavedAddresses.length,


        itemBuilder:
        (context,index){


          final address =
          globalSavedAddresses[index];



          return Container(

            margin:
            const EdgeInsets.only(bottom:16),



            padding:
            const EdgeInsets.all(18),



            decoration:
            BoxDecoration(

              color:
              Colors.white,


              borderRadius:
              BorderRadius.circular(20),



              boxShadow:[

                BoxShadow(

                  color:
                  Colors.black.withOpacity(0.03),

                  blurRadius:12,

                  offset:
                  const Offset(0,5),

                ),

              ],

            ),






            child:Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children:[






                Row(

                  children:[



                    Container(

                      padding:
                      const EdgeInsets.all(10),


                      decoration:
                      BoxDecoration(

                        color:
                        widget.themeColor.withOpacity(0.1),

                        shape:
                        BoxShape.circle,

                      ),



                      child:
                      Icon(

                        address.type=="Home"

                        ? Icons.home_rounded

                        : address.type=="Office"

                        ? Icons.work

                        : Icons.location_on,


                        color:
                        widget.themeColor,

                      ),

                    ),




                    const SizedBox(width:12),





                    Expanded(

                      child:
                      Text(

                        address.type,

                        style:
                        _s(

                          size:16,

                          weight:
                          FontWeight.w800,

                        ),

                      ),

                    ),








                    // EDIT

                    IconButton(

                      icon:
                      Icon(

                        Icons.edit_outlined,

                        color:
                        widget.themeColor,

                      ),


                      onPressed:(){


                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder:(_)=>

                            AddressScreen(

                              isDark:false,

                              themeColor:
                              widget.themeColor,

                            ),

                          ),

                        ).then((_){

                          setState((){});

                        });


                      },

                    ),








                    // DELETE

                    IconButton(

                      icon:
                      const Icon(

                        Icons.delete_outline,

                        color:
                        Colors.red,

                      ),



                      onPressed:(){


                        setState((){

                          globalSavedAddresses
                          .removeAt(index);

                        });


                      },

                    ),


                  ],

                ),






                const SizedBox(height:12),






                Text(

                  address.completeAddress,

                  style:
                  _s(

                    size:13,

                    color:
                    const Color(0xFF6B7280),

                  ),

                ),






                const SizedBox(height:10),






                Text(

                  "${address.fullName}  •  ${address.phone}",

                  style:
                  _s(

                    size:13,

                    weight:
                    FontWeight.w600,

                  ),

                ),



              ],

            ),

          );

        },

      ),


    );


  }


}