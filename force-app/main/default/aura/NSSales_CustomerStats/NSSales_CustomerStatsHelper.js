({
	//parseData: function (component, event, helper) {component.set("v.spinner",!0);var jsonData,action=component.get("c.getCustomerStatisticsData");action.setParams({accId:component.get("v.recordId")}),action.setCallback(this,$A.getCallback(function(t){if("SUCCESS"===t.getState())component.set("v.spinner",!1),jsonData=JSON.parse(t.getReturnValue()),component.set("v.gridData",jsonData),component.set("v.thary",jsonData.result.trafficHistoryAllRollingYear),component.set("v.trafficHistoryAllYTD",jsonData.result.trafficHistoryAllYTD),component.set("v.eyeProfitAllRollingYear",jsonData.result.eyeProfitAllRollingYear),component.set("v.eyeProfitAllYTD",jsonData.result.eyeProfitAllYTD);else if("ERROR"===t.getState()){var e=t.getError();component.set("v.spinner",!1);var o=$A.get("e.force:showToast");o.setParams({title:"Error",duration:12e3,type:"error",message:e[0].message}),o.fire()}})),$A.enqueueAction(action);},

     onInit: function(component, event,helper) {
        console.log("onInit");
        var action = component.get("c.getIntermodalAcc");
        action.setParams({
            accId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var storeResponse = response.getReturnValue();
            var state = response.getState();
            console.log("state" +state);
            console.log("storeResponse" +storeResponse);
            if (storeResponse == 'IM') {
                    component.set("v.isVisibleIP", false);
                component.set("v.isVisibleIM", true);
                 helper.parseDataIM(component, event, helper);
                } else {
                    component.set("v.isVisibleIP", true);
                    component.set("v.isVisibleIM", false);
                    helper.parseData(component, event, helper);
                }
            
        });
        $A.enqueueAction(action);
    },
    
	parseData: function (component, event, helper) {
		component.set("v.spinner", !0);
		var jsonData,
		action = component.get("c.getCustomerStatisticsData");
		action.setParams({
			accId: component.get("v.recordId")
		}),
		action.setCallback(this, $A.getCallback(function (t) {
				if ("SUCCESS" === t.getState()) {
					component.set("v.spinner", !1),
					jsonData = JSON.parse(t.getReturnValue()),
					component.set("v.gridData", jsonData),
					component.set("v.thary", jsonData.result.trafficHistoryAllRollingYear),
					component.set("v.trafficHistoryAllYTD", jsonData.result.trafficHistoryAllYTD),
					component.set("v.eyeProfitAllRollingYear", jsonData.result.eyeProfitAllRollingYear),
					component.set("v.eyeProfitAllYTD", jsonData.result.eyeProfitAllYTD);
					var dateRange1 = component.get("v.thary[0].dateRange");
					var dateRange2 = component.get("v.eyeProfitAllRollingYear[0].dateRange");
					var dateRange3 = component.get("v.trafficHistoryAllYTD[0].dateRange");
					var dateRange4 = component.get("v.eyeProfitAllYTD[0].dateRange");

                    var yearRange1 = dateRange1.substring(0, 4);
                    var monthRange1 = dateRange1.substring(5, 7);
                    var dayRange1 = dateRange1.substring(8, 10);
					var yearRange2 = dateRange1.substring(13, 17);
                    var monthRange2 = dateRange1.substring(18, 20);
                    var dayRange2 = dateRange1.substring(21, 23);

                    var yearRange3 = dateRange2.substring(0, 4);
                    var monthRange3 = dateRange2.substring(5, 7);
                    var dayRange3 = dateRange2.substring(8, 10);
					var yearRange4 = dateRange2.substring(13, 17);
                    var monthRange4 = dateRange2.substring(18, 20);
                    var dayRange4 = dateRange2.substring(21, 23);

                    var yearRange5 = dateRange3.substring(0, 4);
                    var monthRange5 = dateRange3.substring(5, 7);
                    var dayRange5 = dateRange3.substring(8, 10);
					var yearRange6 = dateRange3.substring(13, 17);
                    var monthRange6 = dateRange3.substring(18, 20);
                    var dayRange6 = dateRange3.substring(21, 23);

                    var yearRange7 = dateRange4.substring(0, 4);
                    var monthRange7 = dateRange4.substring(5, 7);
                    var dayRange7 = dateRange4.substring(8, 10);
					var yearRange8 = dateRange4.substring(13, 17);
                    var monthRange8 = dateRange4.substring(18, 20);
                    var dayRange8 = dateRange4.substring(21, 23);

					var formatedDate1 = monthRange1+"/"+dayRange1+"/"+yearRange1 + " - " + monthRange2+"/"+dayRange2+"/"+yearRange2;
					var formatedDate2 = monthRange3+"/"+dayRange3+"/"+yearRange3 + " - " + monthRange4+"/"+dayRange4+"/"+yearRange4;
					var formatedDate3 = monthRange5+"/"+dayRange5+"/"+yearRange5 + " - " + monthRange6+"/"+dayRange6+"/"+yearRange6;
					var formatedDate4 = monthRange7+"/"+dayRange7+"/"+yearRange7 + " - " + monthRange8+"/"+dayRange8+"/"+yearRange8;
                    if(dateRange1!=null){
						component.set("v.formattedDate1", formatedDate1);
                    }
                    if(dateRange2!=null){
						component.set("v.formattedDate2", formatedDate2);
                    }
                    if(dateRange3!=null){
						component.set("v.formattedDate3", formatedDate3);
                    }
                    if(dateRange4!=null){
						component.set("v.formattedDate4", formatedDate4);
                    }
				} else if ("ERROR" === t.getState()) {
					var e = t.getError();
					component.set("v.spinner", !1);
					var o = $A.get("e.force:showToast");
					o.setParams({
						title: "Error",
						duration: 12e3,
						type: "error",
						message: e[0].message
					}),
					o.fire()
				}
			})),
		$A.enqueueAction(action);
	},
    
    parseDataIM: function (component, event, helper) {
		component.set("v.spinner", !0);
		var jsonData,
		action = component.get("c.getCustomerStatisticsDataIM");
		action.setParams({
			accId: component.get("v.recordId")
		}),
		action.setCallback(this, $A.getCallback(function (t) {
				if ("SUCCESS" === t.getState()) {
					component.set("v.spinner", !1),
					jsonData = JSON.parse(t.getReturnValue()),
					component.set("v.gridData", jsonData),
					component.set("v.thary", jsonData.result.trafficHistoryAllRollingYear),
					component.set("v.trafficHistoryAllYTD", jsonData.result.trafficHistoryAllYTD);
					
				} else if ("ERROR" === t.getState()) {
					var e = t.getError();
					component.set("v.spinner", !1);
					var o = $A.get("e.force:showToast");
					o.setParams({
						title: "Error",
						duration: 12e3,
						type: "error",
						message: e[0].message
					}),
					o.fire()
				}
			})),
		$A.enqueueAction(action);
	},

	getJsonData: function () {
		return '{"resultCode":0,"resultDescription":"Success","result":{"trafficHistoryAllRollingYear":{"carloads":20354.12,"carloadsVsPriorPeriod":163.0,"carloadsVsPriorPeriodPerc":0.008072903,"nsRevenue":6.5442416E7,"nsRevenueVsPriorPeriod":2430440.0,"nsRevenueVsPriorPeriodPerc":0.038571082,"nsRevenuePerCar":3215.2117,"nsRevenueVsPriorPeriodPerCar":94.416504,"nsRevenueVsPriorPeriodPerCarPerc":0.03025399,"nsRevenuePerTon":31.5176,"totalRevenue":6.8803952E7,"totalRevenueVsPriorPeriod":2459352.0,"totalRevenueVsPriorPeriodPerc":0.03706936,"totalRevenuePerCar":3380.3652,"totalRevenueVsPriorPeriodPerCar":94.51514,"totalRevenueVsPriorPeriodPerCarPerc":0.028764287,"totalRevenuePerTon":33.13654,"tons":2076377.0,"tonsVsPriorPeriod":31997.0,"tonsVsPriorPeriodPerc":0.0156512,"tonsPerCar":102.013214,"tonsPerCarVsPriorPeriod":0.76116943,"tonsPerCarVsPriorPeriodPerc":0.007517571,"nsRevenueWithoutFsc":6.4704632E7,"nsRevenueWithoutFscVsPriorPeriod":1792676.0,"nsRevenueWithoutFscVsPriorPeriodPerc":0.028494997,"nsRevenueWithoutFscPerCar":3178.9639,"nsRevenueWithoutFscPerTon":31.162275,"nsRevenueWithoutFscPerCarPriorPeriod":63.122314,"nsRevenueWithoutFscVsPriorPeriodPerCarPerc":0.020258512,"nsFuelSurcharge":429683.0,"nsFuelSurchargeVsPriorPeriod":368037.0,"nsFuelSurchargeVsPriorPeriodPerc":5.9701686,"nsFuelSurchargePerCar":21.110495,"nsFuelSurchargePerCarVsPriorPeriod":18.057352,"nsFuelSurchargeVsPriorPeriodPerCarPerc":5.9143496,"nsFuelSurchargePerTon":0.20693882,"totalRevenueWithoutFsc":6.7979E7,"totalRevenueWithoutFscVsPriorPeriod":1762200.0,"totalRevenueWithoutFscVsPriorPeriodPerc":0.026612582,"totalRevenueWithoutFscPerCar":3339.835,"totalRevenueWithoutFscPerCarVsPriorPeriod":60.314453,"totalRevenueWithoutFscPerCarVsPriorPeriodPerc":0.018391242,"totalRevenueWithoutFscPerTon":32.73924,"totalFuelSurcharge":500356.0,"totalFuelSurchargeVsPriorPeriod":415739.0,"totalFuelSurchargeVsPriorPeriodPerc":4.913185,"totalFuelSurchargePerCar":24.582687,"totalFuelSurchargePerCarVsPriorPeriod":20.391861,"totalFuelSurchargePerCarVsPriorPeriodPerc":4.865832,"totalFuelSurchargePerTon":0.24097551},"eyeProfitAllRollingYear":{"carloads":20189.0,"carloadsVsPriorPeriod":24.0,"carloadsVsPriorPeriodPerc":0.0011901810066947682,"totalRevenue":5.941049671845E7,"totalRevenueVsPriorPeriod":-16650.92975999415,"totalRevenueVsPriorPeriodPerc":-2.80190626993616E-4,"totalRevenuePerCar":2942.7161681336374,"totalRevenueVsPriorPeriodPerCar":null,"totalRevenueVsPriorPeriodPerCarPerc":-0.0014686237056478638,"totalRevenuePerTon":28.824171695330932,"tons":2061134.5695,"tonsVsPriorPeriod":16958.65599999996,"tonsVsPriorPeriodPerc":0.00829608444557184,"tonsPerCarVsPriorPeriod":0.7194866835112776,"tonsPerCarVsPriorPeriodPerc":0.0070974561813341285,"tonsPerCar":102.09195945812075,"vecRevCostRatio":1.5594996303392474,"vecRevCostRatioVsPriorPeriod":-0.06466158610693595,"vecRevCostRatioVsPriorPeriodPerc":-0.039812295388028995,"vecCost":3.809587098493E7,"vecCostVsPriorPeriod":1506432.05088,"vecCostVsPriorPeriodPerc":0.04117122576258254,"vecCostPerCar":1886.9617606087475,"vecCostPerCarVsPriorPeriod":72.45945790356518,"vecCostPerCarVsPriorPeriodPerc":0.03993351664284897,"vecCostPerTon":18.48296154392844,"vecContribution":2.131462573352E7,"vecContributionVsPriorPeriod":-1523082.9806399941,"vecContributionVsPriorPeriodPerc":-0.06669158450627062,"vecContributionPerCar":1055.7544075248898,"vecContrPerCarVsPriorPeriod":-76.78755697597785,"vecContrPerCarVsPriorPeriodPerc":-0.06780106996725685,"vecContrPerTon":10.341209310351145,"avgDaysOnLine":24.9449963907301,"avgDaysOnLineVsPriorPeriod":1.3762042076772865,"avgDaysOnLineVsPriorPeriodPerc":0.0583909517716758,"avgLoadedMiles":781.5428421417604,"avgLoadedMilesVsPriorPeriod":28.254045712303423,"avgLoadedMilesVsPriorPeriodPerc":0.03750758785505092,"emptyReturnRatio":0.9547025355603174,"emptyReturnRatioVsPriorPeriod":0.0019419501963242602,"emptyReturnRatioVsPriorPeriodPerc":0.002038235235751652,"nsRevenuePerTonMile":0.03688111532867529,"nsRevenuePerTonMileVsPriorPeriod":-0.001711579985511344,"nsRevenuePerTonMileVsPriorPeriodPerc":-0.04434984319123648,"contributionPerCarDay":42.32329365728922,"contributionPerCarDayVsPriorPeriod":-5.729316711425781,"contributionPerCarDayVsPriorPeriodPerc":-0.11923006477681578},"trafficHistoryAllYTD":{"carloads":5949.0,"carloadsVsPriorPeriod":-646.0,"carloadsVsPriorPeriodPerc":-0.09795299,"nsRevenue":1.9593224E7,"nsRevenueVsPriorPeriod":-680868.0,"nsRevenueVsPriorPeriodPerc":-0.033583157,"nsRevenuePerCar":3293.5325,"nsRevenueVsPriorPeriodPerCar":219.37134,"nsRevenueVsPriorPeriodPerCarPerc":0.07135974,"nsRevenuePerTon":31.99113,"totalRevenue":2.0475432E7,"totalRevenueVsPriorPeriod":-914368.0,"totalRevenueVsPriorPeriodPerc":-0.04274785,"totalRevenuePerCar":3441.8276,"totalRevenueVsPriorPeriodPerCar":198.4917,"totalRevenueVsPriorPeriodPerCarPerc":0.06119986,"totalRevenuePerTon":33.43157,"tons":612458.0,"tonsVsPriorPeriod":-65648.0,"tonsVsPriorPeriodPerc":-0.096810825,"tonsPerCar":102.95142,"tonsPerCarVsPriorPeriod":0.13019562,"tonsPerCarVsPriorPeriodPerc":0.0012662328,"nsRevenueWithoutFsc":1.8590012E7,"nsRevenueWithoutFscVsPriorPeriod":-1636658.0,"nsRevenueWithoutFscVsPriorPeriodPerc":-0.08091584,"nsRevenueWithoutFscPerCar":3124.897,"nsRevenueWithoutFscPerTon":30.35312,"nsRevenueWithoutFscPerCarPriorPeriod":57.926514,"nsRevenueWithoutFscVsPriorPeriodPerCarPerc":0.018887209,"nsFuelSurcharge":91398.0,"nsFuelSurchargeVsPriorPeriod":46941.0,"nsFuelSurchargeVsPriorPeriodPerc":1.0558742,"nsFuelSurchargePerCar":15.36359,"nsFuelSurchargePerCarVsPriorPeriod":8.622574,"nsFuelSurchargeVsPriorPeriodPerCarPerc":1.2791208,"nsFuelSurchargePerTon":0.14923146,"totalRevenueWithoutFsc":1.9451756E7,"totalRevenueWithoutFscVsPriorPeriod":-1875608.0,"totalRevenueWithoutFscVsPriorPeriodPerc":-0.08794373,"totalRevenueWithoutFscPerCar":3269.7522,"totalRevenueWithoutFscPerCarVsPriorPeriod":35.883545,"totalRevenueWithoutFscPerCarVsPriorPeriodPerc":0.011096166,"totalRevenueWithoutFscPerTon":31.760147,"totalFuelSurcharge":102342.0,"totalFuelSurchargeVsPriorPeriod":44344.0,"totalFuelSurchargeVsPriorPeriodPerc":0.7645781,"totalFuelSurchargePerCar":17.203228,"totalFuelSurchargePerCarVsPriorPeriod":8.40899,"totalFuelSurchargePerCarVsPriorPeriodPerc":0.9561931,"totalFuelSurchargePerTon":0.16710044},"eyeProfitAllYTD":{"carloads":1487.0,"carloadsVsPriorPeriod":-412.0,"carloadsVsPriorPeriodPerc":-0.21695629278567669,"totalRevenue":4554780.57667,"totalRevenueVsPriorPeriod":-933999.38155,"totalRevenueVsPriorPeriodPerc":-0.17016520768904972,"totalRevenuePerCar":3063.066964808339,"totalRevenueVsPriorPeriodPerCar":null,"totalRevenueVsPriorPeriodPerCarPerc":0.059755393812033916,"totalRevenuePerTon":29.501754938107876,"tons":154390.157,"tonsVsPriorPeriod":-41904.87049999999,"tonsVsPriorPeriodPerc":-0.21347902202973526,"tonsPerCarVsPriorPeriod":0.45902552700906085,"tonsPerCarVsPriorPeriodPerc":0.004440710938488784,"tonsPerCar":103.82660188298588,"vecRevCostRatio":1.5366645653062487,"vecRevCostRatioVsPriorPeriod":0.07175918827919481,"vecRevCostRatioVsPriorPeriodPerc":0.04898554500825589,"vecCost":2964069.5045,"vecCostVsPriorPeriod":-782779.9810000001,"vecCostVsPriorPeriodPerc":-0.20891684708160668,"vecCostPerCar":1993.3217918628109,"vecCostPerCarVsPriorPeriod":20.257291862810916,"vecCostPerCarVsPriorPeriodPerc":0.0102669182192528,"vecCostPerTon":19.198565258923857,"vecContribution":1590711.0721700005,"vecContributionVsPriorPeriod":-151219.4005499999,"vecContributionVsPriorPeriodPerc":-0.0868113870893325,"vecContributionPerCar":1069.7451729455283,"vecContrPerCarVsPriorPeriod":152.45687767433276,"vecContrPerCarVsPriorPeriodPerc":0.166203884275291,"vecContrPerTon":10.303189211731937,"avgDaysOnLine":20.200650605574985,"avgDaysOnLineVsPriorPeriod":-2.5662478822291206,"avgDaysOnLineVsPriorPeriodPerc":-0.1127183785531359,"avgLoadedMiles":804.0064425016812,"avgLoadedMilesVsPriorPeriod":26.799049136752274,"avgLoadedMilesVsPriorPeriodPerc":0.03448120715981028,"emptyReturnRatio":0.9105846808147876,"emptyReturnRatioVsPriorPeriod":-0.029622052601168236,"emptyReturnRatioVsPriorPeriodPerc":-0.03150589285140035,"nsRevenuePerTonMile":0.0366934310206677,"nsRevenuePerTonMileVsPriorPeriod":7.160455807953478E-4,"nsRevenuePerTonMileVsPriorPeriodPerc":0.019902657517791217,"contributionPerCarDay":52.95597621248395,"contributionPerCarDayVsPriorPeriod":12.665538787841797,"contributionPerCarDayVsPriorPeriodPerc":0.31435595653789894}}}';
	}
})