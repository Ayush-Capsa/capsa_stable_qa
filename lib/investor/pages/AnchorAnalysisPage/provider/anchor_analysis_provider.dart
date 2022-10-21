import 'package:capsa/functions/call_api.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

import 'package:universal_html/html.dart' as html;

class AnchorAnalysisProvider extends ChangeNotifier {
  OpenDealModel _model;

  OpenDealModel get model => _model;

  Future<Object> fetchCreditScore(String panNumber, String year) async {
    var _body = {};
    _body['panNumber'] = panNumber;
    _body['year'] = year;
    var data = await callApi3('/credit/fetchCreditScore', body: _body);
    capsaPrint('creditScoreData: $data');
    CreditScoreModel model = CreditScoreModel(
      data['yearsPresent'].length > 0
          ? data['creditScoreData']
              [data['yearsPresent'][data['yearsPresent'].length - 1]]['result']
          : 0,
      data['yearsPresent'].length > 0
          ? data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['growth'] !=
                  null
              ? int.parse(data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['growth']
                  .toString())
              : 0
          : 0,
      data['yearsPresent'].length > 0
          ? data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['ebidta'] !=
                  null
              ? int.parse(data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['ebidta']
                  .toString())
              : 0
          : 0,
      data['yearsPresent'].length > 0
          ? data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['solvency'] !=
                  null
              ? int.parse(data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['solvency']
                  .toString())
              : 0
          : 0,
      data['yearsPresent'].length > 0
          ? data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['eps'] !=
                  null
              ? int.parse(data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['eps']
                  .toString())
              : 0
          : 0,
      data['yearsPresent'].length > 0
          ? data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['tradeRec'] !=
                  null
              ? int.parse(data['creditScoreData'][data['yearsPresent']
                      [data['yearsPresent'].length - 1]]['tradeRec']
                  .toString())
              : 0
          : 0,
    );
    return model;
  }

  Future<Object> fetchCompanyDetails(String panNumber) async {
    var _body = {};
    _body['panNumber'] = panNumber;
    var data = await callApi3('/credit/fetchCompanyDetails', body: _body);
    capsaPrint('companyDetailsData: $data');
    // CreditScoreModel model = CreditScoreModel(
    //     data['result'],
    //     int.parse(data['growth'].toString()),
    //     int.parse(data['ebidta'].toString()),
    //     int.parse(data['solvency'].toString()),
    //     int.parse(data['eps'].toString()),
    //     int.parse(data['tradeRec'].toString()));
    return data;
  }

  Future<Object> fetchKeyRatios(String panNumber, String year) async {
    var _body = {};
    _body['panNumber'] = panNumber;
    _body['year'] = year;
    var data = await callApi3('/credit/fetchkeyRatios', body: _body);
    // print('Data $data');
    return data;
  }

  Future<Object> fetchProfitAndLoss(String panNumber) async {
    var _body = {};
    _body['panNumber'] = panNumber;
    var data = await callApi3('/credit/pnl', body: _body);
    // capsaPrint('PNL data 1 $panNumber : $data');
    ProfitAndLoss pnlData = ProfitAndLoss([], {}, {}, {}, {}, {});
    //capsaPrint('Profit and loss data ${data['data']['2020']['Revenue']['value']}');
    dynamic yearsPresent = data['yearsPresent'];
    yearsPresent.forEach((element) {
      if (num.tryParse(element.toString()) != null) {
        pnlData.yearsPresent.add(element.toString());
      }
    });
    // pnlData.yearsPresent = yearsPresent;
    capsaPrint(
        'PNL data: ${data['data'][yearsPresent[0].toString()]} \n\n $yearsPresent');
    for (int i = 0; i < yearsPresent.length; i++) {
      if (num.tryParse(yearsPresent[i].toString()) != null) {
        pnlData.revenue[yearsPresent[i].toString()] = data['data']
                [yearsPresent[i].toString()]['Revenue']['value']
            .toString();
        pnlData.EBIT[yearsPresent[i].toString()] = data['data']
                [yearsPresent[i].toString()]['EBIT']['value']
            .toString();
        pnlData.EBITDA[yearsPresent[i].toString()] = data['data']
                [yearsPresent[i].toString()]['EBITDA']['value']
            .toString();
        pnlData.costOfSales[yearsPresent[i].toString()] = data['data']
                [yearsPresent[i].toString()]['Cost_of_sales']['value']
            .toString();
        pnlData.netProfitValue[yearsPresent[i].toString()] = data['data']
                [yearsPresent[i].toString()]['Net_Profit']['value']
            .toString();
      }
    }
    // pnlData.revenue['2020'] =
    //     data['data']['2020']['Revenue']['value'].toString();
    // pnlData.revenue['2021'] =
    //     data['data']['2021']['Revenue']['value'].toString();
    // pnlData.revenue['2022'] =
    //     data['data']['2022']['Revenue']['value'].toString();
    // pnlData.EBIT['2020'] = data['data']['2020']['EBIT']['value'].toString();
    // pnlData.EBIT['2021'] = data['data']['2021']['EBIT']['value'].toString();
    // pnlData.EBIT['2022'] = data['data']['2022']['EBIT']['value'].toString();
    // pnlData.EBITDA['2020'] = data['data']['2020']['EBITDA']['value'].toString();
    // pnlData.EBITDA['2021'] = data['data']['2021']['EBITDA']['value'].toString();
    // pnlData.EBITDA['2022'] = data['data']['2022']['EBITDA']['value'].toString();
    // pnlData.costOfSales['2020'] =
    //     data['data']['2020']['Cost_of_sales']['value'].toString();
    // pnlData.costOfSales['2021'] =
    //     data['data']['2021']['Cost_of_sales']['value'].toString();
    // pnlData.costOfSales['2022'] =
    //     data['data']['2022']['Cost_of_sales']['value'].toString();
    // pnlData.netProfitValue['2020'] =
    //     data['data']['2020']['Net_Profit']['value'].toString();
    // pnlData.netProfitValue['2021'] =
    //     data['data']['2021']['Net_Profit']['value'].toString();
    // pnlData.netProfitValue['2022'] =
    //     data['data']['2022']['Net_Profit']['value'].toString();
    capsaPrint('Profit and loss data ${pnlData}');
    return pnlData;
  }

  Future<Object> fetchBalanceSheet(String panNumber) async {
    var _body = {};
    _body['panNumber'] = panNumber;
    var data = await callApi3('/credit/balancesheet', body: _body);
    capsaPrint('Balance Sheet Data \n $data');
    BalanceSheetModel balance =
        BalanceSheetModel([], {}, {}, {}, {}, {}, {}, {}, {}, {});
    //capsaPrint('Profit and loss data ${data['data'][years[0]]['Total_Current_Assets']}');

    List<dynamic> years = data['yearsPresent'];
    // capsaPrint('Balance sheet Data  X $data \n$years');
    years.forEach((element) {
      if (num.tryParse(element.toString()) != null) {
        balance.yearsPresent.add(element.toString());
      }
    });
    years = balance.yearsPresent;

    for (int i = 0; i < years.length; i++) {

      capsaPrint('\nBalance sheet Data  X \n${data['data'][years[i].toString()]}\n ');

      balance.totalAssets[years[i].toString()] =
          data['data'][years[i].toString()]['Total_Assets']['value'].toString();
      balance.totalCurrentAssets[years[i]] = data['data'][years[i].toString()]
              ['Total_Current_Assets']['value']
          .toString();
      balance.totalNonCurrentAssets[years[i].toString()] = data['data']
              [years[i].toString()]['Total_Non_Current_Assests']['value']
          .toString();
      balance.totalLiabilities[years[i].toString()] = data['data']
              [years[i].toString()]['Total_Liabilites']['value']
          .toString();
      balance.financialDebt[years[i].toString()] = data['data']
              [years[i].toString()]['Fianacial_Debt']['value']
          .toString();
      balance.totalEquityAndLiabilities[years[i].toString()] = data['data']
              [years[i].toString()]['Total_equity_and_liabilities']['value']
          .toString();
      balance.equity[years[i]] =
          data['data'][years[i].toString()]['Equity']['value'].toString();
      balance.totalNonCurrentLiabilities[years[i].toString()] = data['data']
              [years[i].toString()]['Total_Non_current_lliabilities']['value']
          .toString();
      balance.longTermDebt[years[i].toString()] = data['data']
              [years[i].toString()]['Long_term_debt']['value']
          .toString();
    }

    capsaPrint(
        'Balance sheet Data  X2 ${data['data'][years[0].toString()]} \n$years');

    return balance;
  }
}

class ProfitAndLoss {
  dynamic yearsPresent;
  Map<String, String> revenue = {};
  Map<String, String> EBIT = {};
  Map<String, String> EBITDA = {};
  Map<String, String> costOfSales = {};
  Map<String, String> netProfitValue = {};
  ProfitAndLoss(this.yearsPresent, this.revenue, this.EBIT, this.EBITDA,
      this.costOfSales, this.netProfitValue);
}

class BalanceSheetModel {
  dynamic yearsPresent;
  Map<String, String> totalAssets = {};
  Map<String, String> totalCurrentAssets = {};
  Map<String, String> totalNonCurrentAssets = {};
  Map<String, String> totalLiabilities = {};
  Map<String, String> equity = {};
  Map<String, String> financialDebt = {};
  Map<String, String> totalEquityAndLiabilities = {};
  Map<String, String> totalNonCurrentLiabilities = {};
  Map<String, String> longTermDebt = {};
  BalanceSheetModel(
      this.yearsPresent,
      this.totalAssets,
      this.totalCurrentAssets,
      this.totalNonCurrentAssets,
      this.totalLiabilities,
      this.equity,
      this.financialDebt,
      this.totalEquityAndLiabilities,
      this.totalNonCurrentLiabilities,
      this.longTermDebt);
}

class CreditScoreModel {
  double result;
  int growth;
  int ebidta;
  int solvency;
  int eps;
  int traderec;
  CreditScoreModel(this.result, this.growth, this.ebidta, this.solvency,
      this.eps, this.traderec);
}
