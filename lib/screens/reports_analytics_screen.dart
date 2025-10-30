import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  int _selectedChartIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Charts'),
            Tab(text: 'Export'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'This Week', child: Text('This Week')),
              const PopupMenuItem(
                value: 'This Month',
                child: Text('This Month'),
              ),
              const PopupMenuItem(
                value: 'Last 3 Months',
                child: Text('Last 3 Months'),
              ),
              const PopupMenuItem(value: 'This Year', child: Text('This Year')),
              const PopupMenuItem(value: 'Custom', child: Text('Custom Range')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedPeriod,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOverviewTab(), _buildChartsTab(), _buildExportTab()],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics Cards
          Text(
            'Key Metrics',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildMetricCard(
                'Total Hours',
                '176.5h',
                '+12.5h',
                Icons.access_time,
                Colors.blue,
                true,
              ),
              _buildMetricCard(
                'Attendance Rate',
                '94.2%',
                '+2.1%',
                Icons.percent,
                AppTheme.successColor,
                true,
              ),
              _buildMetricCard(
                'Average Daily',
                '8.2h',
                '-0.3h',
                Icons.trending_up,
                AppTheme.warningColor,
                false,
              ),
              _buildMetricCard(
                'Overtime Hours',
                '24.5h',
                '+5.2h',
                Icons.schedule,
                Colors.purple,
                true,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Weekly Summary
          Text(
            'Weekly Summary',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildWeeklyItem('Monday', 8.5, 95, true),
                _buildWeeklyItem('Tuesday', 8.2, 90, true),
                _buildWeeklyItem('Wednesday', 8.8, 98, true),
                _buildWeeklyItem('Thursday', 7.5, 85, false),
                _buildWeeklyItem('Friday', 8.0, 88, true),
                _buildWeeklyItem('Saturday', 0.0, 0, false),
                _buildWeeklyItem('Sunday', 0.0, 0, false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'Recent Activity',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          _buildActivityItem(
            'Check In',
            'Today 09:15 AM',
            Icons.login,
            AppTheme.successColor,
          ),
          _buildActivityItem(
            'Break Start',
            'Today 12:30 PM',
            Icons.pause_circle,
            AppTheme.warningColor,
          ),
          _buildActivityItem(
            'Break End',
            'Today 01:15 PM',
            Icons.play_circle,
            AppTheme.successColor,
          ),
          _buildActivityItem(
            'Overtime Request',
            'Yesterday',
            Icons.schedule,
            Colors.purple,
          ),
          _buildActivityItem(
            'Check Out',
            'Yesterday 06:45 PM',
            Icons.logout,
            AppTheme.errorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      (isPositive ? AppTheme.successColor : AppTheme.errorColor)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                    ),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 10,
                        color: isPositive
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyItem(
    String day,
    double hours,
    int attendance,
    bool isWorkDay,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: isWorkDay ? attendance / 100 : 0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isWorkDay
                    ? attendance >= 90
                          ? AppTheme.successColor
                          : AppTheme.warningColor
                    : Colors.grey[300]!,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Text(
              isWorkDay ? '${hours}h' : 'Off',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isWorkDay ? Colors.black : Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Type Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChartSelector('Attendance Trend', 0),
                _buildChartSelector('Hours Distribution', 1),
                _buildChartSelector('Department Comparison', 2),
                _buildChartSelector('Weekly Pattern', 3),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Chart Container
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildSelectedChart(),
          ),

          const SizedBox(height: 24),

          // Chart Insights
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Insights',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getChartInsight(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSelector(String label, int index) {
    final isSelected = _selectedChartIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedChartIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (_selectedChartIndex) {
      case 0:
        return _buildAttendanceTrendChart();
      case 1:
        return _buildHoursDistributionChart();
      case 2:
        return _buildDepartmentComparisonChart();
      case 3:
        return _buildWeeklyPatternChart();
      default:
        return _buildAttendanceTrendChart();
    }
  }

  Widget _buildAttendanceTrendChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}%');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Text(days[value.toInt() % 7]);
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 95),
              FlSpot(1, 90),
              FlSpot(2, 98),
              FlSpot(3, 85),
              FlSpot(4, 88),
              FlSpot(5, 0),
              FlSpot(6, 0),
            ],
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursDistributionChart() {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}h');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                return Text(days[value.toInt() % 5]);
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 8.5, color: AppTheme.successColor)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 8.2, color: AppTheme.successColor)],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 8.8, color: AppTheme.successColor)],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [BarChartRodData(toY: 7.5, color: AppTheme.warningColor)],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [BarChartRodData(toY: 8.0, color: AppTheme.successColor)],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentComparisonChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 40,
            title: 'Engineering\n40%',
            color: Colors.blue,
            radius: 60,
          ),
          PieChartSectionData(
            value: 25,
            title: 'Design\n25%',
            color: Colors.green,
            radius: 60,
          ),
          PieChartSectionData(
            value: 20,
            title: 'QA\n20%',
            color: Colors.orange,
            radius: 60,
          ),
          PieChartSectionData(
            value: 15,
            title: 'Management\n15%',
            color: Colors.purple,
            radius: 60,
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildWeeklyPatternChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const hours = ['6', '8', '10', '12', '14', '16', '18'];
                return Text(hours[value.toInt() % 7]);
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 8),
              FlSpot(2, 12),
              FlSpot(3, 15),
              FlSpot(4, 18),
              FlSpot(5, 25),
              FlSpot(6, 5),
            ],
            isCurved: true,
            color: Colors.purple,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  String _getChartInsight() {
    switch (_selectedChartIndex) {
      case 0:
        return 'Your attendance rate has improved by 2.1% this month. Wednesday shows the highest attendance rate at 98%.';
      case 1:
        return 'You averaged 8.2 hours per day this week. Thursday was slightly shorter due to early departure.';
      case 2:
        return 'Engineering department has the highest representation at 40%, followed by Design at 25%.';
      case 3:
        return 'Peak activity hours are between 2-4 PM. Consider scheduling important meetings during this time.';
      default:
        return 'No insights available for this chart.';
    }
  }

  Widget _buildExportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Reports',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Quick Export Options
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildExportOption(
                'Monthly Report',
                'Complete attendance summary',
                Icons.calendar_month,
                'PDF',
              ),
              _buildExportOption(
                'Time Sheet',
                'Daily time tracking',
                Icons.access_time,
                'Excel',
              ),
              _buildExportOption(
                'Analytics Report',
                'Charts and insights',
                Icons.bar_chart,
                'PDF',
              ),
              _buildExportOption(
                'Raw Data',
                'All attendance records',
                Icons.table_chart,
                'CSV',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Custom Export
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Export',
                  style: AppTheme.headingSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Date Range Selection
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'From Date',
                        DateTime.now().subtract(const Duration(days: 30)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDateField('To Date', DateTime.now())),
                  ],
                ),

                const SizedBox(height: 16),

                // Report Type Selection
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Report Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'attendance',
                      child: Text('Attendance Summary'),
                    ),
                    DropdownMenuItem(
                      value: 'timesheet',
                      child: Text('Time Sheet'),
                    ),
                    DropdownMenuItem(
                      value: 'analytics',
                      child: Text('Analytics Report'),
                    ),
                    DropdownMenuItem(
                      value: 'custom',
                      child: Text('Custom Report'),
                    ),
                  ],
                  onChanged: (value) {},
                ),

                const SizedBox(height: 16),

                // Format Selection
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Format',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                          DropdownMenuItem(
                            value: 'excel',
                            child: Text('Excel'),
                          ),
                          DropdownMenuItem(value: 'csv', child: Text('CSV')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _generateCustomReport,
                        icon: const Icon(Icons.download),
                        label: const Text('Generate'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent Exports
          Text(
            'Recent Exports',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          _buildRecentExport(
            'Monthly Report - October 2024',
            'PDF • 2.3 MB',
            'Oct 25, 2024',
          ),
          _buildRecentExport(
            'Time Sheet - Week 42',
            'Excel • 1.2 MB',
            'Oct 20, 2024',
          ),
          _buildRecentExport(
            'Analytics Report - Q3 2024',
            'PDF • 3.1 MB',
            'Oct 1, 2024',
          ),
          _buildRecentExport(
            'Raw Data Export - September',
            'CSV • 856 KB',
            'Sep 30, 2024',
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(
    String title,
    String description,
    IconData icon,
    String format,
  ) {
    return Card(
      child: InkWell(
        onTap: () => _exportReport(title, format),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  format,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      controller: TextEditingController(
        text: DateFormat('MMM d, yyyy').format(date),
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          // Handle date selection
        }
      },
    );
  }

  Widget _buildRecentExport(String title, String details, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.file_present, color: AppTheme.primaryColor),
        ),
        title: Text(title),
        subtitle: Text('$details • $date'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Downloading $title')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Sharing $title')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportReport(String title, String format) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_download, size: 48, color: AppTheme.primaryColor),
            const SizedBox(height: 16),
            Text('Export $title as $format?'),
            const SizedBox(height: 8),
            Text(
              'This will include data for $_selectedPeriod',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title exported successfully')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _generateCustomReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Custom Report'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Generating your custom report...'),
          ],
        ),
      ),
    );

    // Simulate report generation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom report generated successfully')),
        );
      }
    });
  }
}
