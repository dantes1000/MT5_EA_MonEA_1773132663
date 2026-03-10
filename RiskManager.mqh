// RiskManager.mqh - Gestion des risques
#property strict

class RiskManager {
private:
    double riskPercent; // Pourcentage de risque par trade
    double stopLossPips; // Stop Loss en pips
    double takeProfitPips; // Take Profit en pips
    double lotSize; // Taille du lot calculée

public:
    // Constructeur
    RiskManager(double risk = 1.0, double sl = 50.0, double tp = 100.0) {
        riskPercent = risk;
        stopLossPips = sl;
        takeProfitPips = tp;
        lotSize = 0.0;
    }

    // Calculer la taille du lot basée sur le risque
    double CalculateLotSize(double accountBalance, double stopLossPrice) {
        double riskAmount = accountBalance * (riskPercent / 100.0);
        double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
        double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
        
        if (tickSize > 0 && tickValue > 0) {
            double stopLossPoints = MathAbs(stopLossPrice) / tickSize;
            lotSize = riskAmount / (stopLossPoints * tickValue);
            lotSize = NormalizeDouble(lotSize, 2); // Arrondir à 2 décimales
        }
        return lotSize;
    }

    // Obtenir le Stop Loss en pips
    double GetStopLossPips() { return stopLossPips; }

    // Obtenir le Take Profit en pips
    double GetTakeProfitPips() { return takeProfitPips; }
};
