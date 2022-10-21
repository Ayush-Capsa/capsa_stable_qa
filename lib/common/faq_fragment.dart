import 'package:capsa/common/responsive.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

class FaqFragment extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? 18 : 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 5 : 30,
            ),
            Container(
              color: Theme.of(context).primaryColor,
              child: Divider(
                height: 1,
                color: Theme.of(context).primaryColor,
                thickness: 0,
              ),
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 8 : 35,
            ),
            buildCard('What is Capsa?',"Capsa is a technology company that has built an online invoice market place  (Factoring) - www.getcapsa.com - where vendors/small businesses can sell their invoices to a  financier at a discounted price. The Capsa’s platform offers businesses a fast and competitive  process to raise working capital to finance ongoing business operations."),
            SizedBox(
              height: 15,
            ),
            buildCard("Is Capsa's factoring the same thing as a loan?","No. Capsa simply gives you an opportunity to  sell your invoices to multiple financers on a single platform. We also give you the power to  determine who can buy your invoice and at what price. Now, tell me if that is not cool. No  other company offer you this much freedom with respect to funding options.  "),
            SizedBox(
              height: 15,
            ),
            buildCard(
                "What is the difference between invoice discounting & factoring?","In Factoring, the financier  is basically lending you (the vendor/business) money with a recourse on the corporate entity  you have issued your invoice against. It means, once you sell your invoice and get your cash,  there is no recourse on you – you take your cash and go away – while the financer wait for the  corporate entity to pay the invoice amount on the due date. Since the financier is not taking  your risk with respect to repayment, you get lower/cheaper rate as the risk priced is that of  the corporate entity which is usually lower than that of the vendor or small businesses."),
            // SizedBox(
            //   height: 15,
            // ),
            // buildCard("Invoice Discounting"," Invoice Discounting on the other hand has no recourse on the corporate entity you have issued  invoices against. The financier will hold the vendor/small business responsible for payment on  due date"),
            SizedBox(
              height: 15,
            ),
            buildCard("What businesses qualify for Capsa's services?","Any business that invoices customers for  payment can use Capsa’s services. It is an excellent source of business finance for many firms  in the B2B and B2G sectors."),
            SizedBox(
              height: 15,
            ),
            buildCard("How does Capsa help my business?","Capsa gives you flexibility and power with respect to how  and when you get your cash. No need to wait for 30 days or more to get your money for services  rendered."),
            SizedBox(
              height: 15,
            ),
            buildCard("Why does Capsa need my BVN?","We require your BVN to verify you and be sure that you are indeed the one registering on our  platform. Be rest assured that Capsa do not have access to your bank account and any other  personal details as a result of this."),
            SizedBox(
              height: 15,
            ),
            buildCard("How Much of My Company's Account Receivables Can Be Funded? ","Capsa allows you to  fund up to 100% of your invoice amount. Now, tell me this is not cool. We don’t do part  funding; we absolutely give you the control that you need."),
            SizedBox(
              height: 15,
            ),
            buildCard("What are Capsa’s factoring rate?"," Capsa does not set rates for the sale of invoices. The rates  are typically determined through a competitive bid and You (yes, You) get to choose the rate  you are most comfortable with or that suits your business goals. However, we charge a little  fee (0.85%) for facilitating the transaction"),
            SizedBox(
              height: 15,
            ),
            buildCard("My passport set link has expired","Your passport link expires after 24 hours. Please click on the  “forget password” button which will require you to set your password and you can proceed  from there."),
            SizedBox(
              height: 15,
            ),
             buildCard("What is 'Buy Now' price?","This is the price set by the vendor for a bilateral / immediate  purchase without going through the competitive bidding process. For instance, a vendor may  indicate a “Buy Now” price of N900,000 on a N1,000,000 invoice. This means, the vendor is  willing to sell the invoice to anyone that offers N900,000 as offer price"),
            SizedBox(
              height: 15,
            ),
             buildCard("How long does it take to get my cash? ","48 hours maximum or earlier. E shock you? No  worries, we understand how important cash is to your business, thus, we have made this fast  and seamless."),
            SizedBox(
              height: 15,
            ),
             buildCard("Can I move money from my Capsa's account to other bank accounts?","Yes, you can. However,  the cash can only be moved to your account with any other bank and not someone’s else  account."),
            SizedBox(
              height: 15,
            ),
             buildCard("What are the applicable for Capsa to other bank funds transfer?","Standard transfer charges  apply."),
            SizedBox(
              height: 15,
            ),
             buildCard("What happens if I don't receive a bid?","Your invoice will be auctioned on the Capsa portal till  you get a bid."),
            SizedBox(
              height: 15,
            ),
             buildCard("Do I require a personal Guarantee?","No, you don’t. No collateral. No Guarantees. Just list  your invoice and sell at a rate / price that suits you. "),
            SizedBox(
              height: 15,
            ),
             buildCard(" What happens if the Buyer of the invoice does not pay? ","This will likely not occur as the  Buyer is expected to have some cash in their account before placing a bid. Should the Buyer  not pay, the platform charges the Buyer a fee which is shared with the vendor to compensate  for the inconvenience. Then, the invoice is re-listed for other potential Buyers on the  platform"),
            SizedBox(
              height: 15,
            ),
             buildCard("What happens if Anchor does not pay on the due date? "," if the invoice is secured, the insurance  company will step-in to pay for this."),
            SizedBox(
              height: 15,
            ),
             buildCard("How do you treat confidentiality information between Anchor & vendor?","We will not  publish confidential information in any transaction. We will only show information required  for a trade"),
            SizedBox(
              height: 15,
            ),
             buildCard(" How do I log issues to get a faster resolution?","Kindly send us an email on  support@getcapsa.com or call us on 0704 627 2950 "),
            SizedBox(
              height: 15,
            ),
             buildCard("Do I have to factor all my invoices on Capsa when I start using Capsa’s services? ","No. You  decide which invoices you want to factor on Capsa, and which invoices you want to keep as  your own. There is no requirement to factor all your invoices."),
            SizedBox(
              height: 15,
            ),
             buildCard("Why should I choose Capsa over other invoice financing companies? ","We are a marketplace that allows you to have access to multiple lenders at the same time which ensures you get a rate that is competitive, and the best you can find compare to other invoice financing  companies."),
            SizedBox(
              height: 15,
            ),
            //  buildCard("",""),
            // SizedBox(
            //   height: 15,
            // ),

          ],
        ),
      ),
    );
  }

  Card buildCard(String title,String body) {
    return Card(
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.1,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Divider(),
          ),
          ListTile(
            title: Text(
              body,
              style: TextStyle(color: Colors.grey[800],  fontSize: 15,),
            ),
          )
        ],
      ),
    );
  }
}
