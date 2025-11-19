# ⚠️ DEPRECATION NOTICE

## This Repository is Deprecated

**QSTrader** is no longer actively maintained by its original authors. The last significant update was in **2019**.

### 🚫 Why Deprecated?

1. **No Active Maintenance**: Original project abandoned
2. **Outdated Dependencies**: Uses deprecated pandas methods (`.append()`, etc.)
3. **Better Alternatives Available**: Modern frameworks with active communities
4. **Security Concerns**: No security updates since 2019

### ✅ Recommended Alternatives

We recommend migrating to one of these actively maintained frameworks:

#### 1. **Lumibot** (Recommended)
- **Repository**: [Chotu-lumibot-dev](https://github.com/CRAJKUMARSINGH/Chotu-lumibot-dev)
- **Why**: Modern, actively maintained, supports live trading
- **Features**: Alpaca, Interactive Brokers, backtesting, paper trading
- **Documentation**: https://lumibot.lumiwealth.com/

```python
# QSTrader → Lumibot Migration Example
# OLD (QSTrader):
class MyStrategy(Strategy):
    def calculate_signals(self, event):
        if event.type == 'MARKET':
            # Generate signals
            pass

# NEW (Lumibot):
from lumibot.strategies import Strategy

class MyStrategy(Strategy):
    def on_trading_iteration(self):
        # Generate signals
        price = self.get_last_price("SPY")
        if price > self.sma_fast:
            self.create_order("SPY", 100, "buy")
```

#### 2. **Backtesting.py**
- **Repository**: [Chotu-backtesting](https://github.com/CRAJKUMARSINGH/Chotu-backtesting)
- **Why**: Simple, fast, great for backtesting
- **Features**: Clean API, built-in optimization, web interface
- **Documentation**: https://kernc.github.io/backtesting.py/

```python
# QSTrader → Backtesting.py Migration
from backtesting import Backtest, Strategy
from backtesting.lib import crossover

class MyStrategy(Strategy):
    def init(self):
        self.sma1 = self.I(SMA, self.data.Close, 10)
        self.sma2 = self.I(SMA, self.data.Close, 20)
    
    def next(self):
        if crossover(self.sma1, self.sma2):
            self.buy()
        elif crossover(self.sma2, self.sma1):
            self.sell()
```

#### 3. **VectorBT**
- **Repository**: [Chotu-vectorbt](https://github.com/CRAJKUMARSINGH/Chotu-vectorbt)
- **Why**: Ultra-fast vectorized backtesting
- **Features**: NumPy-based, parameter optimization, portfolio analysis
- **Documentation**: https://vectorbt.dev/

```python
# QSTrader → VectorBT Migration
import vectorbt as vbt

# Download data
price = vbt.YFData.download("SPY").get("Close")

# Create signals
fast_ma = vbt.MA.run(price, 10)
slow_ma = vbt.MA.run(price, 20)
entries = fast_ma.ma_crossed_above(slow_ma)
exits = fast_ma.ma_crossed_below(slow_ma)

# Backtest
pf = vbt.Portfolio.from_signals(price, entries, exits)
print(pf.stats())
```

### 📋 Migration Guide

#### Step 1: Choose Your Framework
- **Live Trading**: Use Lumibot
- **Fast Backtesting**: Use VectorBT
- **Simple Backtesting**: Use Backtesting.py

#### Step 2: Convert Your Strategy
See examples above for each framework

#### Step 3: Test Thoroughly
```python
# Always backtest before live trading
# Compare results with QSTrader to verify
```

#### Step 4: Deploy
- Lumibot: Can run live with brokers
- Backtesting.py: Web interface available
- VectorBT: Jupyter notebooks or scripts

### 🔧 If You Must Use QSTrader

If you absolutely need to continue using this codebase:

#### Fix Pandas Deprecations:
```python
# Replace all instances of:
df = df.append(new_row)

# With:
df = pd.concat([df, pd.DataFrame([new_row])], ignore_index=True)
```

#### Pin Dependencies:
```txt
# requirements.txt
pandas==1.3.5  # Last version before breaking changes
numpy==1.21.6
```

#### Add Warning:
```python
import warnings
warnings.warn(
    "QSTrader is deprecated. Consider migrating to Lumibot or Backtesting.py",
    DeprecationWarning,
    stacklevel=2
)
```

### 📊 Feature Comparison

| Feature | QSTrader | Lumibot | Backtesting.py | VectorBT |
|---------|----------|---------|----------------|----------|
| Active Development | ❌ No | ✅ Yes | ✅ Yes | ✅ Yes |
| Live Trading | ✅ Yes | ✅ Yes | ❌ No | ❌ No |
| Backtesting | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| Speed | 🐌 Slow | 🚀 Fast | 🚀 Fast | ⚡ Ultra Fast |
| Learning Curve | Medium | Easy | Easy | Medium |
| Documentation | ⚠️ Outdated | ✅ Good | ✅ Excellent | ✅ Good |
| Community | ❌ Dead | ✅ Active | ✅ Active | ✅ Active |

### 🗓️ Timeline

- **2019**: Last QSTrader update
- **2024**: This repository marked as deprecated
- **2025**: Recommend full migration to alternatives

### 📞 Support

For migration help:
- Open an issue in the target repository
- Check documentation links above
- Join community Discord/Slack channels

### 🏛️ Archive Status

This repository will remain available for historical reference but will not receive updates.

---

**Last Updated**: 2025-11-19  
**Status**: DEPRECATED - DO NOT USE FOR NEW PROJECTS
