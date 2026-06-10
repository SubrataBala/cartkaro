import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TrackOrderScreen extends StatelessWidget {

  final Color themeColor;

  const TrackOrderScreen({
    super.key,
    required this.themeColor,
  });


  final String riderName = "Mukesh Bala";

  final String riderNumber = "+91 9876543210";



  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
  }) {

    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );

  }




  // GET INITIALS FROM NAME

  String _getInitials(String name){

    List<String> parts =
    name.trim().split(" ");


    if(parts.length >= 2){

      return
        parts[0][0].toUpperCase() +
        parts[1][0].toUpperCase();

    }


    return
      parts[0][0].toUpperCase();

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

            "Track Order",

            style:_s(

              size:18,

              weight:
              FontWeight.w700,

            ),

          ),

        ),







        body:SingleChildScrollView(

          physics:
          const BouncingScrollPhysics(),


          child:Column(

            children:[




              // MAP AREA


              Container(

                height:260,

                width:
                double.infinity,


                color:
                themeColor.withOpacity(0.08),



                child:Stack(

                  children:[


                    Center(

                      child:Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,


                        children:[


                          Icon(

                            Icons.map_rounded,

                            size:70,

                            color:
                            themeColor,

                          ),


                          const SizedBox(height:10),



                          Text(

                            "Live Tracking Map",

                            style:_s(

                              weight:
                              FontWeight.w700,

                              color:
                              themeColor,

                            ),

                          ),


                          Text(

                            "Google map integration",

                            style:_s(

                              size:12,

                              color:
                              const Color(0xFF6B7280),

                            ),

                          ),

                        ],

                      ),

                    ),





                    Positioned(

                      bottom:20,

                      left:20,

                      right:20,


                      child:Container(

                        padding:
                        const EdgeInsets.all(16),


                        decoration:
                        _box(),



                        child:Row(

                          children:[


                            Icon(

                              Icons.timer,

                              color:
                              themeColor,

                            ),


                            const SizedBox(width:12),



                            Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,


                              children:[


                                Text(

                                  "Estimated Delivery",

                                  style:_s(

                                    size:12,

                                    color:
                                    const Color(0xFF6B7280),

                                  ),

                                ),


                                Text(

                                  "25 - 30 mins",

                                  style:_s(

                                    size:18,

                                    weight:
                                    FontWeight.w800,

                                  ),

                                ),


                              ],

                            )

                          ],

                        ),

                      ),

                    )

                  ],

                ),

              ),







              Padding(

                padding:
                const EdgeInsets.all(20),


                child:Column(

                  children:[



                    _statusCard(),



                    const SizedBox(height:20),



                    _deliveryPartner(),



                    const SizedBox(height:20),




                    _addressCard(),


                  ],

                ),

              )

            ],

          ),

        ),

      ),

    );

  }










  Widget _deliveryPartner(){

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration:
      _box(),



      child:Row(

        children:[





          // INITIAL AVATAR


          Container(

            height:60,

            width:60,


            decoration:
            BoxDecoration(

              color:
              themeColor.withOpacity(0.12),

              shape:
              BoxShape.circle,

            ),


            child:Center(

              child:Text(

                _getInitials(riderName),

                style:_s(

                  size:20,

                  weight:
                  FontWeight.w800,

                  color:
                  themeColor,

                ),

              ),

            ),

          ),






          const SizedBox(width:14),






          Expanded(

            child:Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children:[


                Text(

                  riderName,

                  style:_s(

                    size:15,

                    weight:
                    FontWeight.w800,

                  ),

                ),



                const SizedBox(height:4),



                Text(

                  "Delivery Partner",

                  style:_s(

                    size:12,

                    color:
                    const Color(0xFF6B7280),

                  ),

                ),



                Text(

                  riderNumber,

                  style:_s(

                    size:12,

                    color:
                    const Color(0xFF6B7280),

                  ),

                ),

              ],

            ),

          ),







          _circle(

            Icons.call_rounded,

          ),




          const SizedBox(width:10),





          _circle(

            Icons.chat_bubble_outline_rounded,

          ),



        ],

      ),

    );

  }









  Widget _statusCard(){

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration:
      _box(),


      child:Column(

        children:[


          _step(
              "Order Confirmed",
              true
          ),

          _step(
              "Preparing Order",
              true
          ),

          _step(
              "Out For Delivery",
              true
          ),

          _step(
              "Delivered",
              false
          ),

        ],

      ),

    );

  }






  Widget _step(String text,bool done){

    return ListTile(

      leading:
      Icon(

        done
        ? Icons.check_circle
        : Icons.circle_outlined,

        color:
        done
        ? themeColor
        : Colors.grey,

      ),


      title:
      Text(

        text,

        style:
        _s(
          weight:
          FontWeight.w600,
        ),

      ),

    );

  }









  Widget _addressCard(){

    return Container(

      width:
      double.infinity,


      padding:
      const EdgeInsets.all(18),

      decoration:
      _box(),



      child:Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[



          Text(

            "Delivery Address",

            style:_s(

              size:16,

              weight:
              FontWeight.w800,

            ),

          ),




          const SizedBox(height:12),




          Text(

            "Receiver : Mukesh Bala",

            style:_s(),

          ),




          const SizedBox(height:8),




          Text(

            "ITER College Road, Bhubaneswar, Odisha",

            style:_s(

              color:
              const Color(0xFF6B7280),

            ),

          ),


        ],

      ),

    );

  }










  Widget _circle(IconData icon){

    return CircleAvatar(

      radius:22,


      backgroundColor:
      themeColor.withOpacity(0.12),



      child:Icon(

        icon,

        color:
        themeColor,

        size:20,

      ),

    );

  }







  BoxDecoration _box(){

    return BoxDecoration(

      color:
      Colors.white,


      borderRadius:
      BorderRadius.circular(22),


      boxShadow:[

        BoxShadow(

          color:
          Colors.black.withOpacity(0.03),

          blurRadius:12,

          offset:
          const Offset(0,5),

        )

      ],

    );

  }


}