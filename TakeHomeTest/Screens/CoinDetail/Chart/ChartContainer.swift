//
//  ChartContainer.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Charts
import SwiftUI

struct ChartContainer: View {
    @ObservedObject var viewModel: CoinDetailViewModel

    private var chartColor: Color {
        guard let coinHistory = viewModel.coinHistory,
              viewModel.selectedPoint == nil
        else {
            return .blue
        }

        return coinHistory.change >= 0 ? .green : .red
    }

    var annotationPosition: AnnotationPosition {
        guard let coinHistory = viewModel.coinHistory,
              let selectedPoint = viewModel.selectedPoint
        else {
            return .automatic
        }

        if let index = coinHistory.points.firstIndex(of: selectedPoint),
           index > coinHistory.points.count / 2 {
            return .topTrailing
        } else {
            return .topLeading
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Chart {
                if let points = viewModel.coinHistory?.points {
                    ForEach(points, id: \.id) { point in
                        if let price = point.price {
                            LineMark(
                                x: .value("Time", point.date),
                                y: .value("Price", price)
                            )
                            .foregroundStyle(chartColor)

                            AreaMark(
                                x: .value("Time", point.date),
                                yStart: .value("Price", 0),
                                yEnd: .value("Price", price)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        (chartColor).opacity(0.4),
                                        Color.clear,
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }

                    if let selectedPoint = viewModel.selectedPoint {
                        RuleMark(
                            x: .value("Selected", selectedPoint.date)
                        )
                        .foregroundStyle(Color.gray.opacity(0.3))

                        PointMark(
                            x: .value("Selected", selectedPoint.date),
                            y: .value("Price", selectedPoint.price ?? 0.0)
                        )
                        .foregroundStyle(chartColor)
                        .annotation(position: annotationPosition, spacing: 0) {
                            if let price = selectedPoint.price {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(selectedPoint.date, format: .dateTime.minute().hour().day().month().year())
                                        .font(.footnote)
                                        .foregroundColor(.secondary)

                                    Text(price, format: .currency(code: "USD"))
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                }
                                .padding(2)
                                .background(
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color(.systemBackground))
                                        .shadow(radius: 1)
                                )
                            }
                        }
                    }
                } else {
                    RectangleMark()
                        .annotation(position: .overlay) {
                            Text("No data available")
                                .foregroundColor(.secondary)
                        }
                        .opacity(0)  // Makes the rectangle invisible
                }
            }
            .frame(height: 150)
            .id(viewModel.coinHistory.hashValue)  // Forces a soft reload
            .opacity(viewModel.isLoading ? 0 : 1)  // Smooth transition
            .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
            .chartXAxis {
                AxisMarks { value in
                    if let date = value.as(Date.self) {
                        AxisGridLine()
                        AxisValueLabel(viewModel.selectedTimeframe.dateString(from: date))
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    if let price = value.as(Double.self) {
                        AxisGridLine()
                        AxisValueLabel {
                            if let formattedPrice = NumberFormatter.chartPriceFormatter.string(
                                from: NSNumber(value: price)
                            ) {
                                Text(formattedPrice)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    updateSelectedPoint(
                                        at: value.location,
                                        proxy: proxy,
                                        geometry: geometry)
                                }
                                .onEnded { _ in
                                    viewModel.selectedPoint = nil
                                }
                        )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private func updateSelectedPoint(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        guard let coinHistory = viewModel.coinHistory,
              let plotFrame = proxy.plotFrame
        else { return }

        let xPosition = location.x - geometry[plotFrame].origin.x
        guard let date = proxy.value(atX: xPosition) as Date? else { return }

        // Find the closest data point
        let closestPoint = coinHistory.points.min {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }
        viewModel.selectedPoint = closestPoint
    }
}
