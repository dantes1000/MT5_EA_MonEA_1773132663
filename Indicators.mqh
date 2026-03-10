// Indicators.mqh - Gestion des indicateurs
#property strict

class Indicators {
private:
    int maHandle; // Handle pour la moyenne mobile
    int rsiHandle; // Handle pour le RSI
    double maBuffer[]; // Buffer pour la MA
    double rsiBuffer[]; // Buffer pour le RSI

public:
    // Initialiser les indicateurs
    bool Init() {
        // Moyenne Mobile Simple (SMA) période 14
        maHandle = iMA(_Symbol, PERIOD_CURRENT, 14, 0, MODE_SMA, PRICE_CLOSE);
        if (maHandle == INVALID_HANDLE) {
            Print("Erreur lors de la création de la MA");
            return false;
        }

        // RSI période 14
        rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, 14, PRICE_CLOSE);
        if (rsiHandle == INVALID_HANDLE) {
            Print("Erreur lors de la création du RSI");
            return false;
        }

        // Configurer les buffers
        ArraySetAsSeries(maBuffer, true);
        ArraySetAsSeries(rsiBuffer, true);
        return true;
    }

    // Mettre à jour les données des indicateurs
    bool Update() {
        if (CopyBuffer(maHandle, 0, 0, 3, maBuffer) < 3) {
            Print("Erreur de copie du buffer MA");
            return false;
        }
        if (CopyBuffer(rsiHandle, 0, 0, 3, rsiBuffer) < 3) {
            Print("Erreur de copie du buffer RSI");
            return false;
        }
        return true;
    }

    // Obtenir la valeur actuelle de la MA
    double GetCurrentMA() {
        if (ArraySize(maBuffer) > 0) {
            return maBuffer[0];
        }
        return 0.0;
    }

    // Obtenir la valeur actuelle du RSI
    double GetCurrentRSI() {
        if (ArraySize(rsiBuffer) > 0) {
            return rsiBuffer[0];
        }
        return 0.0;
    }

    // Nettoyer les handles
    void Deinit() {
        if (maHandle != INVALID_HANDLE) IndicatorRelease(maHandle);
        if (rsiHandle != INVALID_HANDLE) IndicatorRelease(rsiHandle);
    }
};
