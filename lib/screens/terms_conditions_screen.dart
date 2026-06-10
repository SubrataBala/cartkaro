import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsConditionsScreen extends StatelessWidget {

  final Color themeColor;


  const TermsConditionsScreen({
    super.key,
    required this.themeColor,
  });




  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
    double? height,
  }) {

    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
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

            'Terms & Conditions',

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

            crossAxisAlignment:
            CrossAxisAlignment.start,



            children: [






              // HEADER CARD


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

                      themeColor,

                      themeColor.withOpacity(0.75),

                    ],

                    begin:
                    Alignment.topLeft,

                    end:
                    Alignment.bottomRight,

                  ),



                  borderRadius:
                  BorderRadius.circular(26),




                  boxShadow: [

                    BoxShadow(

                      color:
                      themeColor.withOpacity(0.3),

                      blurRadius: 20,

                      offset:
                      const Offset(0,8),

                    ),

                  ],

                ),




                child: Column(

                  children: [


                    Container(

                      padding:
                      const EdgeInsets.all(15),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white.withOpacity(0.2),

                        shape:
                        BoxShape.circle,

                      ),



                      child:
                      const Icon(

                        Icons.description_rounded,

                        color:
                        Colors.white,

                        size: 44,

                      ),

                    ),




                    const SizedBox(height: 16),




                    Text(

                      'CartKaro Terms',

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

                      'Please read our terms carefully before using CartKaro services.',

                      textAlign:
                      TextAlign.center,


                      style:
                      _s(

                        size: 13,

                        color:
                        Colors.white70,

                        height: 1.5,

                      ),

                    ),


                  ],

                ),

              ),








              const SizedBox(height: 28),






              _section(

                Icons.account_circle_outlined,

                'Account Responsibility',

                'Users are responsible for maintaining correct personal details, delivery information and account security.',

              ),





              _section(

                Icons.shopping_bag_outlined,

                'Orders & Delivery',

                'Order availability depends on product stock, restaurant availability and delivery partner service area.',

              ),






              _section(

                Icons.payments_outlined,

                'Payments & Refunds',

                'All payments must be completed through approved payment methods. Refunds are processed according to CartKaro refund policy.',

              ),






              _section(

                Icons.cancel_outlined,

                'Cancellation Policy',

                'Orders can only be cancelled within the allowed time period. Completed or dispatched orders may not be cancelled.',

              ),






              _section(

                Icons.card_giftcard_rounded,

                'Rewards & Offers',

                'CartKaro rewards, coupons and offers are subject to availability and may change anytime.',

              ),







              _section(

                Icons.health_and_safety_outlined,

                'Medicine Orders',

                'Medicine delivery follows applicable rules. Some medicines may require prescription verification.',

              ),







              _section(

                Icons.privacy_tip_outlined,

                'Privacy & Security',

                'Your personal information is protected and used only to improve your CartKaro experience.',

              ),








              const SizedBox(height: 20),






              Center(

                child:
                Text(

                  'Last updated : June 2026',

                  style:
                  _s(

                    size: 12,

                    color:
                    const Color(0xFF9CA3AF),

                  ),

                ),

              ),






              const SizedBox(height: 40),




            ],

          ),

        ),

      ),

    );

  }









  Widget _section(

      IconData icon,

      String title,

      String desc,

      ){



    return Container(

      margin:
      const EdgeInsets.only(bottom: 14),



      padding:
      const EdgeInsets.all(18),



      decoration:
      BoxDecoration(

        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(20),



        border:
        Border.all(

          color:
          const Color(0xFFE5E7EB),

        ),



        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(0.02),

            blurRadius: 10,

            offset:
            const Offset(0,4),

          ),

        ],

      ),






      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,



        children: [



          Container(

            padding:
            const EdgeInsets.all(10),



            decoration:
            BoxDecoration(

              color:
              themeColor.withOpacity(0.1),


              shape:
              BoxShape.circle,

            ),



            child:
            Icon(

              icon,

              color:
              themeColor,

              size: 22,

            ),

          ),




          const SizedBox(width: 14),





          Expanded(

            child:
            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [



                Text(

                  title,

                  style:
                  _s(

                    size: 15,

                    weight:
                    FontWeight.w800,

                  ),

                ),





                const SizedBox(height: 6),





                Text(

                  desc,


                  style:
                  _s(

                    size: 12.5,

                    color:
                    const Color(0xFF6B7280),

                    height: 1.5,

                  ),

                ),



              ],

            ),

          ),



        ],

      ),

    );

  }

}