import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CartKaroPlusScreen extends StatelessWidget {

  final Color themeColor;


  const CartKaroPlusScreen({
    super.key,
    required this.themeColor,
  });




  final int currentCoins = 1250;
  final int requiredCoins = 2000;



  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
  }) {

    return TextStyle(
      fontFamily: "Poppins",
      fontSize: size,
      fontWeight: weight,
      color: color,
    );

  }







  @override
  Widget build(BuildContext context) {


    double progress =
        currentCoins / requiredCoins;



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

          elevation:0,

          centerTitle:true,


          leading:IconButton(

            icon:const Icon(

              Icons.arrow_back_ios_new_rounded,

              color:
              Colors.black,

              size:20,

            ),


            onPressed:()=>Navigator.pop(context),

          ),



          title:Text(

            "CartKaro Plus",

            style:_s(

              size:18,

              weight:
              FontWeight.w800,

            ),

          ),

        ),








        body:SingleChildScrollView(

          physics:
          const BouncingScrollPhysics(),


          padding:
          const EdgeInsets.all(20),



          child:Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children:[









              // PREMIUM CARD


              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(28),


                decoration:
                BoxDecoration(

                  gradient:
                  const LinearGradient(

                    colors:[

                      Color(0xFF001923),

                      Color(0xFF05394A),

                    ],

                  ),


                  borderRadius:
                  BorderRadius.circular(28),


                  boxShadow:[

                    BoxShadow(

                      color:
                      Colors.black.withOpacity(0.2),

                      blurRadius:20,

                      offset:
                      const Offset(0,8),

                    )

                  ],

                ),






                child:Column(

                  children:[



                    const Icon(

                      Icons.flash_on,

                      color:
                      Colors.amber,

                      size:50,

                    ),





                    const SizedBox(height:12),





                    const Text(

                      "CartKaro\nPlus",

                      textAlign:
                      TextAlign.center,

                      style:
                      TextStyle(

                        fontFamily:"Poppins",

                        color:
                        Colors.white,

                        fontSize:32,

                        fontWeight:
                        FontWeight.w900,

                      ),

                    ),






                    const SizedBox(height:12),





                    Text(

                      "Unlock using coins or buy membership",

                      style:
                      _s(

                        color:
                        Colors.white70,

                      ),

                    )



                  ],

                ),

              ),







              const SizedBox(height:25),









              // COINS PROGRESS



              _sectionTitle(
                  "Unlock With Coins"
              ),





              Container(

                padding:
                const EdgeInsets.all(18),


                decoration:
                _box(),



                child:Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,



                  children:[



                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children:[


                        Text(

                          "$currentCoins / $requiredCoins Coins",

                          style:
                          _s(

                            weight:
                            FontWeight.w800,

                          ),

                        ),




                        Text(

                          "${requiredCoins-currentCoins} left",

                          style:
                          _s(

                            color:
                            themeColor,

                            weight:
                            FontWeight.w700,

                          ),

                        )

                      ],

                    ),





                    const SizedBox(height:12),






                    LinearProgressIndicator(

                      value:
                      progress,


                      color:
                      themeColor,


                      minHeight:8,


                      borderRadius:
                      BorderRadius.circular(10),

                    ),





                    const SizedBox(height:12),





                    Text(

                      "Earn 50 coins on every order",

                      style:
                      _s(

                        size:12,

                        color:
                        const Color(0xFF6B7280),

                      ),

                    )


                  ],

                ),

              ),







              const SizedBox(height:25),






              _sectionTitle(
                  "Plus Benefits"
              ),








              _benefit(

                Icons.monetization_on,

                "50 Coins Every Order",

                "Collect coins faster with every purchase",

              ),






              _benefit(

                Icons.local_offer,

                "Extra Discount Boost",

                "20% offer becomes 25% for Plus users",

              ),






              _benefit(

                Icons.delivery_dining,

                "Free Delivery",

                "Free delivery on orders above ₹179",

              ),







              _benefit(

                Icons.confirmation_num,

                "Plus Coupons",

                "Access special Plus only coupons",

              ),









              const SizedBox(height:25),









              _sectionTitle(
                  "Your Savings"
              ),






              Row(

                children:[


                  Expanded(

                    child:
                    _savingBox(

                      "₹340",

                      "Delivery Saved",

                    ),

                  ),



                  const SizedBox(width:12),




                  Expanded(

                    child:
                    _savingBox(

                      "450",

                      "Coins Earned",

                    ),

                  ),



                ],

              ),







              const SizedBox(height:25),







              _sectionTitle("FAQ"),



              _faq(

                "Can I unlock without paying?",

                "Yes, collect 2000 coins to unlock Plus.",

              ),



              _faq(

                "How long membership lasts?",

                "Plus membership is valid for 3 months.",

              ),









              const SizedBox(height:30),








              ElevatedButton(

                onPressed:(){},


                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  themeColor,


                  minimumSize:
                  const Size(

                    double.infinity,

                    55,

                  ),

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(18),

                  ),

                ),




                child:
                const Text(

                  "Join Plus ₹99 / 3 Months",

                  style:
                  TextStyle(

                    color:
                    Colors.white,

                    fontWeight:
                    FontWeight.w800,

                  ),

                ),

              ),






              const SizedBox(height:30),



            ],

          ),

        ),

      ),

    );


  }








  Widget _sectionTitle(String t){

    return Padding(

      padding:
      const EdgeInsets.only(bottom:12),


      child:
      Text(

        t,

        style:
        _s(

          size:17,

          weight:
          FontWeight.w800,

        ),

      ),

    );

  }








  Widget _benefit(
      IconData icon,
      String title,
      String sub){


    return ListTile(

      leading:
      Icon(

        icon,

        color:
        themeColor,

      ),


      title:
      Text(

        title,

        style:
        _s(

          weight:
          FontWeight.w800,

        ),

      ),


      subtitle:
      Text(sub),

    );

  }








  Widget _savingBox(
      String value,
      String text){


    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration:
      _box(),


      child:
      Column(

        children:[


          Text(

            value,

            style:
            _s(

              size:22,

              weight:
              FontWeight.w900,

              color:
              themeColor,

            ),

          ),



          Text(

            text,

            style:
            _s(size:12),

          )


        ],

      ),

    );

  }









  Widget _faq(String q,String a){

    return ExpansionTile(

      title:
      Text(q),

      children:[

        Text(a)

      ],

    );

  }








  BoxDecoration _box(){

    return BoxDecoration(

      color:
      Colors.white,


      borderRadius:
      BorderRadius.circular(20),


      boxShadow:[

        BoxShadow(

          color:
          Colors.black.withOpacity(0.03),

          blurRadius:12,

        )

      ],

    );

  }


}