import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PaymentsScreen extends StatefulWidget {

  final Color themeColor;


  const PaymentsScreen({
    super.key,
    required this.themeColor,
  });


  @override
  State<PaymentsScreen> createState()
  => _PaymentsScreenState();

}




class _PaymentsScreenState
    extends State<PaymentsScreen> {


  List<Map<String,String>> cards = [

    {
      "bank":"HDFC Bank",
      "number":"**** **** **** 4582",
      "type":"Visa"
    },

  ];



  List<String> upis = [

    "mukesh@upi"

  ];






  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF111827),
  }){

    return TextStyle(

      fontFamily:"Poppins",

      fontSize:size,

      fontWeight:weight,

      color:color,

    );

  }








  @override
  Widget build(BuildContext context){


    return AnnotatedRegion<SystemUiOverlayStyle>(


      value:
      const SystemUiOverlayStyle(

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

            icon:
            const Icon(

              Icons.arrow_back_ios_new_rounded,

              size:20,

              color:
              Color(0xFF111827),

            ),



            onPressed:()=>
            Navigator.pop(context),

          ),





          title:
          Text(

            "Payments",

            style:
            _s(

              size:18,

              weight:
              FontWeight.w700,

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







              // WALLET CARD


              Container(

                width:
                double.infinity,


                padding:
                const EdgeInsets.all(24),



                decoration:
                BoxDecoration(

                  gradient:
                  LinearGradient(

                    colors:[

                      widget.themeColor,

                      widget.themeColor
                      .withOpacity(0.75),

                    ],

                  ),



                  borderRadius:
                  BorderRadius.circular(26),

                ),





                child:Column(

                  children:[


                    const Icon(

                      Icons.account_balance_wallet_rounded,

                      size:45,

                      color:
                      Colors.white,

                    ),




                    const SizedBox(height:12),





                    Text(

                      "CartKaro Wallet",

                      style:
                      _s(

                        size:20,

                        weight:
                        FontWeight.w800,

                        color:
                        Colors.white,

                      ),

                    ),






                    const SizedBox(height:6),




                    Text(

                      "₹1,250.00",

                      style:
                      _s(

                        size:32,

                        weight:
                        FontWeight.w900,

                        color:
                        Colors.white,

                      ),

                    ),




                  ],

                ),

              ),







              const SizedBox(height:30),





              _title("Saved Cards"),






              ...cards.map((card){


                return _paymentTile(

                  Icons.credit_card,

                  card["bank"]!,

                  "${card["number"]} • ${card["type"]}",

                  trailing:
                  Icons.delete_outline,

                );


              }),








              _addButton(

                Icons.add_card,

                "Add New Card",

              ),









              const SizedBox(height:25),







              _title("UPI Payments"),





              ...upis.map((upi){


                return _paymentTile(

                  Icons.currency_rupee,

                  upi,

                  "UPI ID",

                  trailing:
                  Icons.delete_outline,

                );


              }),








              _addButton(

                Icons.add,

                "Add UPI ID",

              ),









              const SizedBox(height:25),






              _title("Other Payment Methods"),






              _paymentTile(

                Icons.card_giftcard,

                "Gift Card",

                "Redeem your gift balance",

              ),







              _paymentTile(

                Icons.payments_outlined,

                "Cash on Delivery",

                "Pay after receiving order",

              ),








              const SizedBox(height:25),







              Container(

                padding:
                const EdgeInsets.all(16),


                decoration:
                BoxDecoration(

                  color:
                  widget.themeColor.withOpacity(0.08),


                  borderRadius:
                  BorderRadius.circular(18),

                ),



                child:Row(

                  children:[



                    Icon(

                      Icons.lock,

                      color:
                      widget.themeColor,

                    ),



                    const SizedBox(width:12),



                    Expanded(

                      child:
                      Text(

                        "100% secure payments powered by CartKaro protection.",

                        style:
                        _s(

                          size:12,

                          color:
                          const Color(0xFF6B7280),

                        ),

                      ),

                    )


                  ],

                ),

              ),







              const SizedBox(height:40),


            ],

          ),

        ),

      ),

    );


  }









  Widget _title(String text){

    return Padding(

      padding:
      const EdgeInsets.only(bottom:12),


      child:
      Text(

        text,

        style:
        _s(

          size:15,

          weight:
          FontWeight.w800,

        ),

      ),

    );

  }









  Widget _paymentTile(
      IconData icon,
      String title,
      String subtitle,
      {IconData? trailing}
      ){


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
        CircleAvatar(

          backgroundColor:
          widget.themeColor.withOpacity(0.1),


          child:
          Icon(

            icon,

            color:
            widget.themeColor,

          ),

        ),




        title:
        Text(

          title,

          style:
          _s(

            weight:
            FontWeight.w700,

          ),

        ),



        subtitle:
        Text(

          subtitle,

          style:
          _s(

            size:12,

            color:
            const Color(0xFF6B7280),

          ),

        ),




        trailing:

        trailing==null

        ? null

        : Icon(

          trailing,

          color:
          Colors.red,

        ),

      ),

    );

  }









  Widget _addButton(
      IconData icon,
      String text){


    return GestureDetector(

      onTap:(){},


      child:
      Container(

        padding:
        const EdgeInsets.all(16),


        margin:
        const EdgeInsets.only(bottom:12),


        decoration:
        BoxDecoration(

          borderRadius:
          BorderRadius.circular(18),


          border:
          Border.all(

            color:
            widget.themeColor,

          ),

        ),



        child:
        Row(

          children:[


            Icon(

              icon,

              color:
              widget.themeColor,

            ),



            const SizedBox(width:12),




            Text(

              text,

              style:
              _s(

                weight:
                FontWeight.w700,

                color:
                widget.themeColor,

              ),

            ),

          ],

        ),

      ),

    );


  }



}