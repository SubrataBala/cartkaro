import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class CartKaroEliteScreen extends StatelessWidget {

  final Color themeColor;



  const CartKaroEliteScreen({
    super.key,
    required this.themeColor,
  });





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

            icon:
            const Icon(

              Icons.arrow_back_ios_new_rounded,

              color:
              Colors.black,

              size:20,

            ),



            onPressed:()=>
                Navigator.pop(context),

          ),






          title:
          Text(

            "CartKaro Elite",

            style:
            _s(

              size:18,

              weight:
              FontWeight.w800,

            ),

          ),

        ),








        body:
        SingleChildScrollView(

          physics:
          const BouncingScrollPhysics(),


          padding:
          const EdgeInsets.all(20),





          child:
          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,



            children:[








              // ELITE CARD


              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(30),




                decoration:
                BoxDecoration(

                  gradient:
                  const LinearGradient(

                    colors:[

                      Color(0xFF000000),

                      Color(0xFF252525),

                    ],

                  ),



                  borderRadius:
                  BorderRadius.circular(30),




                  boxShadow:[


                    BoxShadow(

                      color:
                      Colors.black.withOpacity(0.25),

                      blurRadius:25,

                      offset:
                      const Offset(0,10),

                    )

                  ],

                ),








                child:
                Column(

                  children:[






                    const Icon(

                      Icons.workspace_premium_rounded,

                      color:
                      Colors.amber,

                      size:55,

                    ),







                    const SizedBox(height:14),







                    const Text(

                      "CartKaro\nElite",

                      textAlign:
                      TextAlign.center,


                      style:
                      TextStyle(

                        fontFamily:
                        "Poppins",

                        fontSize:34,

                        fontWeight:
                        FontWeight.w900,


                        color:
                        Colors.amber,

                      ),

                    ),







                    const SizedBox(height:15),








                    const Text(

                      "Premium Membership\n₹249 / 3 Months",


                      textAlign:
                      TextAlign.center,


                      style:
                      TextStyle(

                        color:
                        Colors.white70,

                        fontSize:14,

                      ),

                    ),






                  ],

                ),

              ),











              const SizedBox(height:25),










              // STATUS


              _sectionTitle(
                "Membership Status",
              ),





              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(18),


                decoration:
                _box(),




                child:
                Row(

                  children:[



                    CircleAvatar(

                      backgroundColor:
                      Colors.amber.withOpacity(0.15),


                      child:
                      const Icon(

                        Icons.star,

                        color:
                        Colors.amber,

                      ),

                    ),






                    const SizedBox(width:15),








                    Expanded(

                      child:
                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children:[


                          Text(

                            "Become Elite Member",

                            style:
                            _s(

                              weight:
                              FontWeight.w800,

                            ),

                          ),





                          const SizedBox(height:4),




                          Text(

                            "Unlock premium benefits today",

                            style:
                            _s(

                              size:12,

                              color:
                              const Color(0xFF6B7280),

                            ),

                          ),


                        ],

                      ),

                    )

                  ],

                ),

              ),












              const SizedBox(height:25),








              _sectionTitle(
                "Elite Benefits",
              ),








              _benefit(

                Icons.flash_on,

                "Early Festival Access",

                "Get sale offers 1 day before everyone",

              ),









              _benefit(

                Icons.delivery_dining,

                "Free Delivery",

                "Free delivery on orders above ₹149",

              ),









              _benefit(

                Icons.payments,

                "Lower Platform Fee",

                "₹11 platform fee becomes only ₹7",

              ),









              _benefit(

                Icons.monetization_on,

                "70 Coins Every Order",

                "Earn more rewards on every purchase",

              ),










              _benefit(

                Icons.local_offer,

                "Maximum Discounts",

                "Get highest value discount coupons",

              ),










              _benefit(

                Icons.support_agent,

                "Priority Support",

                "Faster help from CartKaro support",

              ),










              const SizedBox(height:25),









              _sectionTitle(

                "Your Elite Savings",

              ),








              Row(

                children:[




                  Expanded(

                    child:
                    _savingBox(

                      "₹2450",

                      "Total Saved",

                    ),

                  ),








                  const SizedBox(width:12),








                  Expanded(

                    child:
                    _savingBox(

                      "980",

                      "Coins Earned",

                    ),

                  ),




                ],

              ),












              const SizedBox(height:25),








              _sectionTitle(
                "Upcoming Advantage",
              ),








              Container(

                padding:
                const EdgeInsets.all(18),



                decoration:
                _box(),




                child:
                Row(

                  children:[



                    const Text(

                      "🎉",

                      style:
                      TextStyle(fontSize:35),

                    ),




                    const SizedBox(width:15),






                    Expanded(

                      child:
                      Text(

                        "Festival sale access starts 1 day early for Elite members.",

                        style:
                        _s(

                          weight:
                          FontWeight.w600,

                        ),

                      ),

                    )

                  ],

                ),

              ),











              const SizedBox(height:25),







              _sectionTitle("FAQ"),








              _faq(

                "Can I unlock Elite with coins?",

                "No. Elite is a premium paid membership only.",

              ),







              _faq(

                "How long is Elite valid?",

                "Elite membership is valid for 3 months.",

              ),










              const SizedBox(height:30),











              ElevatedButton(


                onPressed:(){},




                style:
                ElevatedButton.styleFrom(


                  backgroundColor:
                  Colors.black,


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

                  "Join Elite ₹249 / 3 Months",


                  style:
                  TextStyle(

                    color:
                    Colors.amber,


                    fontWeight:
                    FontWeight.w900,

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












  Widget _sectionTitle(String text){


    return Padding(

      padding:
      const EdgeInsets.only(bottom:12),


      child:
      Text(

        text,

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
      String sub,
      ){


    return ListTile(

      leading:
      Icon(

        icon,

        color:
        Colors.amber,

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
      String text,
      ){



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
              Colors.amber.shade700,

            ),

          ),




          Text(

            text,

            style:
            _s(

              size:12,

            ),

          )

        ],

      ),

    );


  }










  Widget _faq(
      String q,
      String a,
      ){

    return ExpansionTile(

      title:
      Text(

        q,

        style:
        _s(

          weight:
          FontWeight.w700,

        ),

      ),



      children:[

        Padding(

          padding:
          const EdgeInsets.all(12),


          child:
          Text(a),

        )

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