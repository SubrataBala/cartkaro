import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'rating_review_screen.dart';



class MyOrdersScreen extends StatelessWidget {

  final Color themeColor;


  const MyOrdersScreen({
    super.key,
    required this.themeColor,
  });





  final List<Map<String,dynamic>> orders = const [


    {

      "id":"#CK10245",

      "date":"08 Jun 2026",

      "status":"Delivered",

      "amount":"₹450",

      "items":[

        "Milk 1L",

        "Bread",

        "Rice 5kg"

      ]

    },




    {

      "id":"#CK10212",

      "date":"02 Jun 2026",

      "status":"Delivered",

      "amount":"₹280",

      "items":[

        "Paneer Butter Masala",

        "Butter Naan"

      ]

    },


  ];






  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
  }){

    return TextStyle(

      fontFamily:'Poppins',

      fontSize:size,

      fontWeight:weight,

      color:color,

    );

  }







  @override
  Widget build(BuildContext context) {


    return AnnotatedRegion<SystemUiOverlayStyle>(

      value:const SystemUiOverlayStyle(

        statusBarColor:
        Colors.transparent,

        statusBarIconBrightness:
        Brightness.dark,

      ),




      child:Scaffold(

        backgroundColor:
        const Color(0xFFFAFAFC),





        appBar:AppBar(

          backgroundColor:
          Colors.white,


          elevation:0,


          centerTitle:true,



          leading:IconButton(

            icon:const Icon(

              Icons.arrow_back_ios_new_rounded,

              color:
              Color(0xFF111827),

              size:20,

            ),



            onPressed:()=>
            Navigator.pop(context),

          ),





          title:Text(

            "My Orders",

            style:_s(

              size:18,

              weight:
              FontWeight.w700,

            ),

          ),

        ),







        body:ListView.builder(

          physics:
          const BouncingScrollPhysics(),


          padding:
          const EdgeInsets.all(20),



          itemCount:
          orders.length,



          itemBuilder:(context,index){


            final order =
            orders[index];



            return _orderCard(

              context,

              order,

            );


          },

        ),


      ),

    );


  }










  Widget _orderCard(
      BuildContext context,
      Map<String,dynamic> order,
      ){


    return Container(

      margin:
      const EdgeInsets.only(bottom:18),


      padding:
      const EdgeInsets.all(18),




      decoration:
      BoxDecoration(

        color:
        Colors.white,



        borderRadius:
        BorderRadius.circular(22),



        border:
        Border.all(

          color:
          const Color(0xFFE5E7EB),

        ),




        boxShadow:[

          BoxShadow(

            color:
            Colors.black.withOpacity(0.03),

            blurRadius:12,

            offset:
            const Offset(0,5),

          )

        ],

      ),







      child:Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,



        children:[







          // TOP


          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,



            children:[




              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[


                  Text(

                    order["id"],

                    style:_s(

                      size:15,

                      weight:
                      FontWeight.w800,

                    ),

                  ),




                  const SizedBox(height:4),




                  Text(

                    order["date"],

                    style:_s(

                      size:12,

                      color:
                      const Color(0xFF6B7280),

                    ),

                  ),

                ],

              ),







              Container(

                padding:
                const EdgeInsets.symmetric(

                  horizontal:12,

                  vertical:6,

                ),



                decoration:
                BoxDecoration(

                  color:
                  themeColor.withOpacity(0.1),

                  borderRadius:
                  BorderRadius.circular(20),

                ),



                child:Text(

                  order["status"],


                  style:_s(

                    size:12,

                    weight:
                    FontWeight.w700,

                    color:
                    themeColor,

                  ),

                ),

              )


            ],

          ),








          const SizedBox(height:16),





          const Divider(),







          const SizedBox(height:10),








          // ITEMS


          ...List.generate(

            order["items"].length,


                (i){

              return Padding(

                padding:
                const EdgeInsets.only(bottom:8),



                child:Row(

                  children:[



                    Icon(

                      Icons.check_circle,

                      size:18,

                      color:
                      themeColor,

                    ),



                    const SizedBox(width:10),





                    Expanded(

                      child:
                      Text(

                        order["items"][i],

                        style:_s(

                          size:13,

                          weight:
                          FontWeight.w500,

                        ),

                      ),

                    )


                  ],

                ),

              );


            },

          ),







          const SizedBox(height:10),








          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,


            children:[



              Text(

                "${order["items"].length} Items",

                style:_s(

                  color:
                  const Color(0xFF6B7280),

                ),

              ),




              Text(

                order["amount"],

                style:_s(

                  size:16,

                  weight:
                  FontWeight.w800,

                ),

              ),



            ],

          ),







          const SizedBox(height:18),







          Row(

            children:[






              Expanded(

                child:
                OutlinedButton.icon(

                  onPressed:(){},


                  icon:
                  Icon(

                    Icons.refresh,

                    color:
                    themeColor,

                  ),



                  label:
                  Text(

                    "Reorder",

                    style:
                    TextStyle(

                      color:
                      themeColor,

                      fontWeight:
                      FontWeight.w700,

                    ),

                  ),



                  style:
                  OutlinedButton.styleFrom(

                    side:
                    BorderSide(

                      color:
                      themeColor,

                    ),


                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(14),

                    ),

                  ),

                ),

              ),







              const SizedBox(width:12),








              Expanded(

                child:
                ElevatedButton.icon(

                  onPressed:(){


                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:(_)=>

                        RatingReviewScreen(

                          themeColor:
                          themeColor,

                        ),

                      ),

                    );


                  },



                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    themeColor,


                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(14),

                    ),

                  ),




                  icon:
                  const Icon(

                    Icons.star,

                    color:
                    Colors.white,

                    size:18,

                  ),




                  label:
                  const Text(

                    "Rate",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.w700,

                    ),

                  ),


                ),

              ),


            ],

          )


        ],

      ),

    );


  }



}