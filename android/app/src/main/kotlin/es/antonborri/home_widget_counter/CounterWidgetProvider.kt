
package es.antonborri.weather_app
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetPlugin


class CounterWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
            widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.counter_widget  ).apply {
                val count = widgetData.getInt("counter", 0)
                val f = widgetData.getInt("x", 0)
                val c = widgetData.getInt("weather_degree", 0)

                setTextViewText(R.id.text_counter, c.toString()+"°C ")
                setTextViewText(R.id.text_counter2, f.toString()+"°F " )
                // val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(
                //         context,
                //         Uri.parse("homeWidgetCounter://increment")
                // )
                // val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
                //         context,
                //         Uri.parse("homeWidgetCounter://refresh")
                // )

                // setOnClickPendingIntent(R.id.button_refresh, refreshIntent)

            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}