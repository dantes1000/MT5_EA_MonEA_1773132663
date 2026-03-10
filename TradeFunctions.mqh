// TradeFunctions.mqh - Fonctions de trading
#property strict
#include "RiskManager.mqh"

class TradeFunctions {
private:
    RiskManager *riskManager;

public:
    // Constructeur
    TradeFunctions(RiskManager &rm) {
        riskManager = &rm;
    }

    // Ouvrir un ordre d'achat (BUY)
    bool OpenBuyOrder() {
        double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        double stopLoss = ask - (riskManager.GetStopLossPips() * _Point);
        double takeProfit = ask + (riskManager.GetTakeProfitPips() * _Point);
        
        double lotSize = riskManager.CalculateLotSize(AccountInfoDouble(ACCOUNT_BALANCE), stopLoss - ask);
        if (lotSize <= 0) {
            Print("Taille du lot invalide");
            return false;
        }

        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        request.action = TRADE_ACTION_DEAL;
        request.symbol = _Symbol;
        request.volume = lotSize;
        request.type = ORDER_TYPE_BUY;
        request.price = ask;
        request.sl = stopLoss;
        request.tp = takeProfit;
        request.deviation = 10;
        request.magic = 12345;
        request.comment = "Achat via MonEA";

        if (OrderSend(request, result)) {
            Print("Ordre BUY ouvert. Ticket: ", result.order);
            return true;
        } else {
            Print("Erreur d'ouverture BUY. Code: ", result.retcode);
            return false;
        }
    }

    // Ouvrir un ordre de vente (SELL)
    bool OpenSellOrder() {
        double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        double stopLoss = bid + (riskManager.GetStopLossPips() * _Point);
        double takeProfit = bid - (riskManager.GetTakeProfitPips() * _Point);
        
        double lotSize = riskManager.CalculateLotSize(AccountInfoDouble(ACCOUNT_BALANCE), stopLoss - bid);
        if (lotSize <= 0) {
            Print("Taille du lot invalide");
            return false;
        }

        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        request.action = TRADE_ACTION_DEAL;
        request.symbol = _Symbol;
        request.volume = lotSize;
        request.type = ORDER_TYPE_SELL;
        request.price = bid;
        request.sl = stopLoss;
        request.tp = takeProfit;
        request.deviation = 10;
        request.magic = 12345;
        request.comment = "Vente via MonEA";

        if (OrderSend(request, result)) {
            Print("Ordre SELL ouvert. Ticket: ", result.order);
            return true;
        } else {
            Print("Erreur d'ouverture SELL. Code: ", result.retcode);
            return false;
        }
    }

    // Fermer tous les ordres ouverts
    void CloseAllOrders() {
        for (int i = OrdersTotal() - 1; i >= 0; i--) {
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
                if (OrderSymbol() == _Symbol && OrderMagicNumber() == 12345) {
                    MqlTradeRequest request = {};
                    MqlTradeResult result = {};
                    request.action = TRADE_ACTION_DEAL;
                    request.symbol = OrderSymbol();
                    request.volume = OrderLots();
                    request.type = (OrderType() == ORDER_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
                    request.price = SymbolInfoDouble(_Symbol, (OrderType() == ORDER_TYPE_BUY) ? SYMBOL_BID : SYMBOL_ASK);
                    request.deviation = 10;
                    request.magic = OrderMagicNumber();
                    request.comment = "Fermeture via MonEA";

                    if (!OrderSend(request, result)) {
                        Print("Erreur de fermeture. Ticket: ", OrderTicket(), " Code: ", result.retcode);
                    }
                }
            }
        }
    }
};
