//
//  StatsView.swift
//  SoFit
//
//  Created by Jonas Barth on 02.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct StatsView: View {
    @FetchRequest(entity: TBL_Practice.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TBL_Practice.timestamp, ascending: true)]) var practices: FetchedResults<TBL_Practice>
    @FetchRequest(entity: FitnessLevel.entity(), sortDescriptors: []) var level: FetchedResults<FitnessLevel>
    
    @Binding var selected: String
    @State var pickerSelected = 0
    @State var barData: [[CGFloat]] = [[0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2],
                                       [0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2],
                                       [0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2,
                                        0.1, 0.2, 0.2, 0.3, 0.2]]
    
    @State var lineData: [[Double]] = [[1,2,3,4], [1,2,3,4], [1,2,3,4]]
    @State var barNames: [[String]] = [["1", "2", "3", "4"]]
    @State var motTextn: [String] = [""]
    @State var motText1: [String] = [""]
    
    // Split Workouts indexes in smaller time intervalls to show 4 Bars per Week / Month / 2Weeks
    @State var weeklyBarData0: [[Int]] = []
    @State var weeklyBarData1: [[Int]] = []
    @State var weeklyBarData2: [[Int]] = []
    @State var weeklyBarData3: [[Int]] = []
    
    @State var biMonthlyBarData0: [[Int]] = []
    @State var biMonthlyBarData1: [[Int]] = []
    @State var biMonthlyBarData2: [[Int]] = []
    @State var biMonthlyBarData3: [[Int]] = []
    
    @State var monthlyBarData0: [[Int]] = []
    @State var monthlyBarData1: [[Int]] = []
    @State var monthlyBarData2: [[Int]] = []
    @State var monthlyBarData3: [[Int]] = []
    
    private let mot0 = Calendar.current.date(byAdding: .day, value: -30, to: Date())
    private let bmt0 = Calendar.current.date(byAdding: .day, value: -15, to: Date())
    private let wkt0 = Calendar.current.date(byAdding: .day, value: -7, to: Date())
    
    private let wkt1 = Calendar.current.date(byAdding: .day, value: -5, to: Date())
    private let wkt2 = Calendar.current.date(byAdding: .day, value: -3, to: Date())
    private let wkt3 = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    
    private let bmt1 = Calendar.current.date(byAdding: .day, value: -12, to: Date())
    private let bmt2 = Calendar.current.date(byAdding: .day, value: -8, to: Date())
    private let bmt3 = Calendar.current.date(byAdding: .day, value: -4, to: Date())
    
    private let mot1 = Calendar.current.date(byAdding: .day, value: -22, to: Date())
    private let mot2 = Calendar.current.date(byAdding: .day, value: -15, to: Date())
    private let mot3 = Calendar.current.date(byAdding: .day, value: -8, to: Date())
    
    private let tn = Calendar.current.date(byAdding: .day, value: 0, to: Date())
    private let devFit: [String] = ["oops, poor fitness this time", "do more, get addicted to fitness", "refuse to loose!", "your fitness slipped slightly", "try harder", "your fitness is on track", "you grew amazing stronger", "you're outperforming the strongest athlets", "you're skyrocketing strong"]
    private let devComm: [String] = ["you're kidding, you can do more", "failure is not an option, stay commited", "listen to your shoulder angel", "keep the ball rolling", "closed to schedule, keep working out", "in line with schedule", "what an energized week", "your committment is stellar", "you're a workout maniac"]
    private let formatter = DateFormatter()
    private let myChartSytle = ChartStyle(backgroundColor: .white, accentColor: .white, gradientColor: GradientColor(start: Color("Medium Persian Blue"), end: Color("Medium Persian Blue")), textColor: Color("font"), legendTextColor: Color("lightFont"), dropShadowColor: .black)
    
    init(selected: Binding<String>) {
        self._selected = selected
        self.formatter.dateFormat = "d/MMM"
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    LineView(data: self.lineData[pickerSelected], legend: "Fitness Progress", style: myChartSytle)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Achievements").foregroundColor(Color("lightFont")).font(.system(size: 16)).padding(.leading, 5)
                            SeperaterView(color: Color.gray.opacity(0.3), label: Text("Your level is \(fitnessClassData[Int(self.level[0].level)].name.rawValue)"))
                            SeperaterView(color: Color.gray.opacity(0.3), label: Text("Fitness: \(self.motTextn[self.pickerSelected])"))
                            SeperaterView(color: .white, label: Text("Committment: \(self.motText1[self.pickerSelected])"))
                            
                        }
                        
                        HStack {
                            Text("Bodypart Progress").foregroundColor(Color("lightFont")).font(.system(size: 16)).padding(.leading, 5)
                            Spacer()
                        }
                        
                        HStack(spacing: 18) {
                            BarView(value1: self.barData[pickerSelected][0], value2: self.barData[pickerSelected][1], value3: self.barData[pickerSelected][2], value4: self.barData[pickerSelected][3], value5: self.barData[pickerSelected][4], name: self.barNames[pickerSelected][0], height: 200)
                            
                            BarView(value1: self.barData[pickerSelected][5], value2: self.barData[pickerSelected][6], value3: self.barData[pickerSelected][7], value4: self.barData[pickerSelected][8], value5: self.barData[pickerSelected][9], name: self.barNames[pickerSelected][1], height: 200)
                            
                            BarView(value1: self.barData[pickerSelected][10], value2: self.barData[pickerSelected][11], value3: self.barData[pickerSelected][12], value4: self.barData[pickerSelected][13], value5: self.barData[pickerSelected][14], name: self.barNames[pickerSelected][2], height: 200)
                            
                            BarView(value1: self.barData[pickerSelected][15], value2: self.barData[pickerSelected][16], value3: self.barData[pickerSelected][17], value4: self.barData[pickerSelected][18], value5: self.barData[pickerSelected][19], name: self.barNames[pickerSelected][3], height: 200)
                        }.animation(.default)
                        
                        HStack(spacing: 20) {
                            Text("Chest").foregroundColor(Color("Cool Black"))
                            Text("Back").foregroundColor(Color("Medium Persian Blue"))
                            Text("Abs").foregroundColor(Color("Tufts Blue"))
                            Text("Glutes").foregroundColor(Color("Blue Jeans"))
                            Text("Quads").foregroundColor(Color("Pale Robin Egg Blue"))
                        }
                    }
                    
                    
                    Picker(selection: $pickerSelected, label: Text("")) {
                        Text("1W").tag(0)
                        Text("2W").tag(1)
                        Text("1M").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                    
                }.navigationBarTitle(Text("Stats").foregroundColor(Color("font")), displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {self.selected = "Home"}) {
                        Image(systemName: "arrowshape.turn.up.left").resizable()
                            .frame(width: 25, height: 25, alignment: .leading)
                            .foregroundColor(Color("font"))
                    })
            }
        }.onAppear {
            var monthlyLineData: [Double] = []
            var biMonthlyLineData: [Double] = []
            var weeklyLineData: [Double] = []
            
            self.barNames.remove(at: 0)
            self.barNames.append([self.formatter.string(from: self.tn!) + " - " + self.formatter.string(from: self.wkt3!),
                                  self.formatter.string(from: self.wkt3!) + " - " + self.formatter.string(from: self.wkt2!),
                                  self.formatter.string(from: self.wkt2!) + " - " + self.formatter.string(from: self.wkt1!),
                                  self.formatter.string(from: self.wkt1!) + " - " + self.formatter.string(from: self.wkt0!)])
            
            self.barNames.append([self.formatter.string(from: self.tn!) + " - " + self.formatter.string(from: self.bmt3!),
                                  self.formatter.string(from: self.bmt3!) + " - " + self.formatter.string(from: self.bmt2!),
                                  self.formatter.string(from: self.bmt2!) + " - " + self.formatter.string(from: self.bmt1!),
                                  self.formatter.string(from: self.bmt1!) + " - " + self.formatter.string(from: self.bmt0!)])
            
            self.barNames.append([self.formatter.string(from: self.tn!) + " - " + self.formatter.string(from: self.mot3!),
                                  self.formatter.string(from: self.mot3!) + " - " + self.formatter.string(from: self.mot2!),
                                  self.formatter.string(from: self.mot2!) + " - " + self.formatter.string(from: self.mot1!),
                                  self.formatter.string(from: self.mot1!) + " - " + self.formatter.string(from: self.mot0!)])
            
            if self.practices.count > 0 {
                for i in 0..<self.practices.count {
                    if self.practices[i].timestamp! > self.mot0! && self.practices[i].timestamp! <= self.tn! {
                        monthlyLineData.append(self.practices[i].newScore)
                        
                        // Get monthly Data in big Intervalls to feed the Bar Chart
                        if self.practices[i].timestamp! >= self.mot0! && self.practices[i].timestamp! < self.mot1! {
                            self.monthlyBarData0.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.mot1! && self.practices[i].timestamp! < self.mot2! {
                            self.monthlyBarData1.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.mot2! && self.practices[i].timestamp! < self.mot3! {
                            self.monthlyBarData2.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.mot3! && self.practices[i].timestamp! <= self.tn! {
                            self.monthlyBarData3.append([Int(self.practices[i].workoutID) - 1, i])
                        }
                    }
                    
                    if self.practices[i].timestamp! > self.bmt0! && self.practices[i].timestamp! <= self.tn! {
                        biMonthlyLineData.append(self.practices[i].newScore)
                        
                        // Get bimonthly Data in Intervalls to feed the Bar Chart
                        if self.practices[i].timestamp! >= self.bmt0! && self.practices[i].timestamp! < self.bmt1! {
                            self.biMonthlyBarData0.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.bmt1! && self.practices[i].timestamp! < self.bmt2! {
                            self.biMonthlyBarData1.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.bmt2! && self.practices[i].timestamp! < self.bmt3! {
                            self.biMonthlyBarData2.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.bmt3! && self.practices[i].timestamp! <= self.tn! {
                            self.biMonthlyBarData3.append([Int(self.practices[i].workoutID) - 1, i])
                        }
                    }
                    
                    if self.practices[i].timestamp! > self.wkt0! && self.practices[i].timestamp! <= self.tn! {
                        weeklyLineData.append(self.practices[i].newScore)
                        
                        // Get weekly Data in small Intervalls to feed the Bar Chart
                        if self.practices[i].timestamp! >= self.wkt0! && self.practices[i].timestamp! < self.wkt1! {
                            self.weeklyBarData0.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.wkt1! && self.practices[i].timestamp! < self.wkt2! {
                            self.weeklyBarData1.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.wkt2! && self.practices[i].timestamp! < self.wkt3! {
                            self.weeklyBarData2.append([Int(self.practices[i].workoutID) - 1, i])
                            
                        } else if self.practices[i].timestamp! >= self.wkt3! && self.practices[i].timestamp! <= self.tn! {
                            self.weeklyBarData3.append([Int(self.practices[i].workoutID) - 1, i])
                        }
                    }
                }
                // Set Line Chart Data
                self.lineData.remove(at: 2)
                self.lineData.remove(at: 1)
                self.lineData.remove(at: 0)
                self.lineData.append(weeklyLineData)
                self.lineData.append(biMonthlyLineData)
                self.lineData.append(monthlyLineData)
                
                // Pick Motivational Slogan
                let devFitIncrease: Double = weeklyLineData[weeklyLineData.count - 1] / weeklyLineData[0]
                let devFitBiMonthly: Double = (biMonthlyLineData[biMonthlyLineData.count - 1] / biMonthlyLineData[Int(biMonthlyLineData.count / 2)]) / 2 + (biMonthlyLineData[Int(biMonthlyLineData.count / 2)] / biMonthlyLineData[0]) / 2
                let devFitMonthly: Double = (monthlyLineData[monthlyLineData.count - 1] / monthlyLineData[Int(monthlyLineData.count / 4 * 3)]) / 4
                    + (monthlyLineData[monthlyLineData.count / 4 * 3] / monthlyLineData[Int(monthlyLineData.count / 2)]) / 4
                    + (monthlyLineData[monthlyLineData.count / 2] / monthlyLineData[Int(monthlyLineData.count / 4)]) / 4
                    + (monthlyLineData[monthlyLineData.count / 4] / monthlyLineData[0]) / 4
                
                let countWorkouts: Double = Double(weeklyLineData.count) / Double(30)
                let countBiMonthly: Double = Double(biMonthlyLineData.count) / Double(60)
                let countMonthly: Double = Double(monthlyLineData.count) / Double(120)
                
                self.motTextn.remove(at: 0)
                self.getDevFitMsg(rate: devFitIncrease)
                self.getDevFitMsg(rate: devFitBiMonthly)
                self.getDevFitMsg(rate: devFitMonthly)
                
                self.motText1.remove(at: 0)
                self.getDevCommMsg(countWorkouts: countWorkouts)
                self.getDevCommMsg(countWorkouts: countBiMonthly)
                self.getDevCommMsg(countWorkouts: countMonthly)
                
                
                self.fillBarDataArray()
            }
        }
    }
    
    func getDevFitMsg(rate: Double) {
        if rate < 0.63 {
            self.motTextn.append(self.devFit[0])
        } else if rate < 0.75 && rate >= 0.63 {
            self.motTextn.append(self.devFit[1])
        } else if rate < 0.83 && rate >= 0.75 {
            self.motTextn.append(self.devFit[2])
        } else if rate < 0.92 && rate >= 0.83 {
            self.motTextn.append(self.devFit[3])
        } else if rate < 1 && rate >= 0.92 {
            self.motTextn.append(self.devFit[4])
        } else if rate < 1.33 && rate >= 1 {
            self.motTextn.append(self.devFit[5])
        } else if rate < 1.67 && rate >= 1.33 {
            self.motTextn.append(self.devFit[6])
        } else if rate < 2 && rate >= 1.67 {
            self.motTextn.append(self.devFit[7])
        } else {
            self.motTextn.append("unknown commitment")
        }
    }
    
    func getDevCommMsg(countWorkouts: Double) {
        if countWorkouts < 0.33 {
            self.motText1.append(self.devComm[0])
        } else if countWorkouts < 0.5 && countWorkouts >= 0.33 {
            self.motText1.append(self.devComm[1])
        } else if countWorkouts < 0.67 && countWorkouts >= 0.5 {
            self.motText1.append(self.devComm[2])
        } else if countWorkouts < 0.83 && countWorkouts >= 0.67 {
            self.motText1.append(self.devComm[3])
        } else if countWorkouts < 1 && countWorkouts >= 0.83 {
            self.motText1.append(self.devComm[4])
        } else if countWorkouts < 1.33 && countWorkouts >= 1 {
            self.motText1.append(self.devComm[5])
        } else if countWorkouts < 1.67 && countWorkouts >= 1.33 {
            self.motText1.append(self.devComm[6])
        } else if countWorkouts < 2 && countWorkouts >= 1.67 {
            self.motText1.append(self.devComm[7])
        } else {
            self.motText1.append("unknown commitment")
        }
    }
    
    func fillBarDataArray() {
        var weeklyBarData: [CGFloat] = []
        var biMonthlyBarData: [CGFloat] = []
        var monthlyBarData: [CGFloat] = []
        let arrayOfTheArrays = [self.weeklyBarData3, self.weeklyBarData2, self.weeklyBarData1, self.weeklyBarData0,
                                self.biMonthlyBarData3, self.biMonthlyBarData2, self.biMonthlyBarData1, self.biMonthlyBarData0,
                                self.monthlyBarData3, self.monthlyBarData2, self.monthlyBarData1, self.monthlyBarData0]
        
        for j in 0..<arrayOfTheArrays.count {
            var chest: Double = 0
            var back: Double = 0
            var abs: Double = 0
            var glutes: Double = 0
            var quads: Double = 0
            var total: Double = 0
            
            for i in 0..<arrayOfTheArrays[j].count {
                switch workoutData[arrayOfTheArrays[j][i][0]].bodypart {
                case Bodypart.Chest : chest += self.practices[arrayOfTheArrays[j][i][1]].actLvl
                case Bodypart.Back : back += self.practices[arrayOfTheArrays[j][i][1]].actLvl
                case Bodypart.Abs : abs += self.practices[arrayOfTheArrays[j][i][1]].actLvl
                case Bodypart.Glutes : glutes += self.practices[arrayOfTheArrays[j][i][1]].actLvl
                case Bodypart.Quads : quads += self.practices[arrayOfTheArrays[j][i][1]].actLvl
                }
            }
            if chest != 0 || back != 0 || abs != 0 || glutes != 0 || quads != 0 {
                total = chest + back + abs + glutes + quads
            } else {
                total = 1
            }
            
            if j < 4 {
                weeklyBarData.append(CGFloat(chest/total))
                weeklyBarData.append(CGFloat(back/total))
                weeklyBarData.append(CGFloat(abs/total))
                weeklyBarData.append(CGFloat(glutes/total))
                weeklyBarData.append(CGFloat(quads/total))
                
            } else if j >= 4 && j < 8 {
                biMonthlyBarData.append(CGFloat(chest/total))
                biMonthlyBarData.append(CGFloat(back/total))
                biMonthlyBarData.append(CGFloat(abs/total))
                biMonthlyBarData.append(CGFloat(glutes/total))
                biMonthlyBarData.append(CGFloat(quads/total))
                
            } else {
                monthlyBarData.append(CGFloat(chest/total))
                monthlyBarData.append(CGFloat(back/total))
                monthlyBarData.append(CGFloat(abs/total))
                monthlyBarData.append(CGFloat(glutes/total))
                monthlyBarData.append(CGFloat(quads/total))
            }
        }
        self.barData.remove(at: 2)
        self.barData.remove(at: 1)
        self.barData.remove(at: 0)
        self.barData.append(weeklyBarData)
        self.barData.append(biMonthlyBarData)
        self.barData.append(monthlyBarData)
    }
}

struct SeperaterView<Content: View>: View {
    private var color: Color
    private var label: Content

    init(color: Color, label: Content) {
        self.color = color
        self.label = label
    }
    var body: some View {
        ZStack {
            Rectangle().frame(width: UIScreen.main.bounds.width, height: 70)
                .foregroundColor(color)
                .offset(y: 3)
            Rectangle().frame(width: UIScreen.main.bounds.width, height: 70)
                .foregroundColor(.white)
            label.font(.system(size: 20))
                .padding(.leading, 15)
                .padding(.trailing, 15)
        }
    }
}

struct BarView: View {
    var value1: CGFloat
    var value2: CGFloat
    var value3: CGFloat
    var value4: CGFloat
    var value5: CGFloat
    var name: String
    var height: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Capsule().frame(width: 30, height: height)
                    .foregroundColor(.white)
                Capsule().frame(width: 30, height: value1*height + value2*height + value3*height + value4*height + value5*height)
                    .foregroundColor(Color("Pale Robin Egg Blue"))
                Capsule().frame(width: 30, height: value1*height + value2*height + value3*height + value4*height)
                    .foregroundColor(Color("Blue Jeans"))
                Capsule().frame(width: 30, height: value1*height + value2*height + value3*height)
                    .foregroundColor(Color("Tufts Blue"))
                Capsule().frame(width: 30, height: value1*height + value2*height)
                    .foregroundColor(Color("Medium Persian Blue"))
                Capsule().frame(width: 30, height: value1*height)
                    .foregroundColor(Color("Cool Black"))
            }
            Text(name).foregroundColor(Color("font"))
                .font(.system(size: 10))
                .padding(.top, 8)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(selected: Binding.constant("Stats"))
    }
}
