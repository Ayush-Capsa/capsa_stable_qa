import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class FaqPAGE extends StatefulWidget {
  const FaqPAGE({Key key}) : super(key: key);

  @override
  State<FaqPAGE> createState() => _FaqPAGEState();
}

class _FaqPAGEState extends State<FaqPAGE> {
  final quesAns = [
    {
      'ques': "What is Capsa?",
      'ans':
          "Capsa is a technology company that has built an online invoice market place  (Factoring) - www.getcapsa.com - where vendors/small businesses can sell their invoices to a  financier at a discounted price. The Capsa’s platform offers businesses a fast and competitive  process to raise working capital to finance ongoing business operations.",
    },
    {
      'ques': "Is Capsa's factoring the same thing as a loan?",
      'ans':
          "No. Capsa simply gives you an opportunity to  sell your invoices to multiple financers on a single platform. We also give you the power to  determine who can buy your invoice and at what price. Now, tell me if that is not cool. No  other company offer you this much freedom with respect to funding options.  ",
    },
    {
      'ques': "What is the difference between invoice discounting & factoring?",
      'ans':
          "In Factoring, the financier  is basically lending you (the vendor/business) money with a recourse on the corporate entity  you have issued your invoice against. It means, once you sell your invoice and get your cash,  there is no recourse on you – you take your cash and go away – while the financer wait for the  corporate entity to pay the invoice amount on the due date. Since the financier is not taking  your risk with respect to repayment, you get lower/cheaper rate as the risk priced is that of  the corporate entity which is usually lower than that of the vendor or small businesses.",
    },
    {
      'ques': "What businesses qualify for Capsa's services?",
      'ans':
          "Any business that invoices customers for  payment can use Capsa’s services. It is an excellent source of business finance for many firms  in the B2B and B2G sectors.",
    },
    {
      'ques': "How does Capsa help my business?",
      'ans':
          "Capsa gives you flexibility and power with respect to how  and when you get your cash. No need to wait for 30 days or more to get your money for services  rendered.",
    },
    {
      'ques': "Why does Capsa need my BVN?",
      'ans':
          "We require your BVN to verify you and be sure that you are indeed the one registering on our  platform. Be rest assured that Capsa do not have access to your bank account and any other  personal details as a result of this.",
    },
    {
      'ques': "How Much of My Company's Account Receivables Can Be Funded? ",
      'ans':
          "Capsa allows you to  fund up to 100% of your invoice amount. Now, tell me this is not cool. We don’t do part  funding; we absolutely give you the control that you need.",
    },
    {
      'ques': "What are Capsa’s factoring rate?",
      'ans':
          "Capsa does not set rates for the sale of invoices. The rates  are typically determined through a competitive bid and You (yes, You) get to choose the rate  you are most comfortable with or that suits your business goals. However, we charge a little  fee (0.85%) for facilitating the transaction",
    },
    {
      'ques': "My passport set link has expired",
      'ans':
          "Your passport link expires after 24 hours. Please click on the  “forget password” button which will require you to set your password and you can proceed  from there.",
    },
    {
      'ques': "What is 'Buy Now' price?",
      'ans':
          "This is the price set by the vendor for a bilateral / immediate  purchase without going through the competitive bidding process. For instance, a vendor may  indicate a “Buy Now” price of N900,000 on a N1,000,000 invoice. This means, the vendor is  willing to sell the invoice to anyone that offers N900,000 as offer price",
    },
    {
      'ques': "How long does it take to get my cash? ",
      'ans':
          "48 hours maximum or earlier. E shock you? No  worries, we understand how important cash is to your business, thus, we have made this fast  and seamless.",
    },
    {
      'ques': "Can I move money from my Capsa's account to other bank accounts?",
      'ans': "Yes, you can. However,  the cash can only be moved to your account with any other bank and not someone’s else  account.",
    },
    {
      'ques': "What are the applicable for Capsa to other bank funds transfer?",
      'ans': "Standard transfer charges  apply.",
    },
    {
      'ques': "What happens if I don't receive a bid?",
      'ans': "Your invoice will be auctioned on the Capsa portal till  you get a bid.",
    },
    {
      'ques': "Do I require a personal Guarantee?",
      'ans': "No, you don’t. No collateral. No Guarantees. Just list  your invoice and sell at a rate / price that suits you.",
    },
    {
      'ques': "What happens if the Buyer of the invoice does not pay?",
      'ans':
          "This will likely not occur as the  Buyer is expected to have some cash in their account before placing a bid. Should the Buyer  not pay, the platform charges the Buyer a fee which is shared with the vendor to compensate  for the inconvenience. Then, the invoice is re-listed for other potential Buyers on the  platform",
    },
    {
      'ques': "What happens if Anchor does not pay on the due date? ",
      'ans': "if the invoice is secured, the insurance  company will step-in to pay for this",
    },
    {
      'ques': "How do you treat confidentiality information between Anchor & vendor?",
      'ans': "We will not  publish confidential information in any transaction. We will only show information required  for a trade",
    },
    {
      'ques': " How do I log issues to get a faster resolution?",
      'ans': "Kindly send us an email on  support@getcapsa.com or call us on 0704 627 2950",
    },
    {
      'ques': "Do I have to factor all my invoices on Capsa when I start using Capsa’s services?",
      'ans':
          "No. You  decide which invoices you want to factor on Capsa, and which invoices you want to keep as  your own. There is no requirement to factor all your invoices.",
    },
    {
      'ques': "Why should I choose Capsa over other invoice financing companies?",
      'ans':
          "We are a marketplace that allows you to have access to multiple lenders at the same time which ensures you get a rate that is competitive, and the best you can find compare to other invoice financing  companies.",
    },
  ];
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25,25,25,10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            TopBarWidget("Frequently Asked Questions", ""),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: getTextWidgets(),
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(
                    width: 15,
                  ),
                if (!Responsive.isMobile(context))
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, left: 2, bottom: 10),
                      child: Container(

                        constraints: BoxConstraints(minHeight: 480),


                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(0),
                          ),
                          boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.10000000149011612), offset: Offset(10, 10), blurRadius: 20)],
                          color: Color.fromRGBO(245, 251, 255, 1),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      quesAns[currentIndex]['ques'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      quesAns[currentIndex]['ans'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          // fontFamily: 'Poppins',
                                          fontSize: 16,
                                          letterSpacing: 0.1 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1.5),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getTextWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < quesAns.length; i++) {
      list.add(questionWidget(quesAns[i]['ques'], i));
    }
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: list),
        ));
  }

  Widget questionWidget(text, index) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: (currentIndex == index) ? HexColor("#0098DB") : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(25, 0, 0, 0),
                            offset: Offset(5.0, 5.0),
                            blurRadius: 1.0,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 255, 255, 255),
                            offset: Offset(-5.0, -5.0),
                            blurRadius: 0.0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                text,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: (currentIndex == index) ? Color.fromRGBO(242, 242, 242, 1) : Colors.black87,
                                    fontSize: 15,
                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1.4),
                              ),
                            ),
                            Icon(
                              (Responsive.isMobile(context))
                                  ? ((currentIndex == index) ? Icons.keyboard_arrow_up_sharp : Icons.keyboard_arrow_down_sharp)
                                  : Icons.arrow_forward_ios_sharp,
                              size: 18,
                              color: (currentIndex == index) ? Colors.white : Colors.black87,
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
            if ((currentIndex == index) && Responsive.isMobile(context))
              SizedBox(
                height: 10,
              ),
            if ((currentIndex == index) && Responsive.isMobile(context))
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(25, 0, 0, 0),
                      offset: Offset(1.0, 1.0),
                      blurRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 255, 255),
                      offset: Offset(-1.0, -1.0),
                      blurRadius: 0.0,
                    )
                  ],
                  color: HexColor("#F5FBFF"),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quesAns[currentIndex]['ans'],
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 15, letterSpacing: 1, fontWeight: FontWeight.normal, height: 1),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
