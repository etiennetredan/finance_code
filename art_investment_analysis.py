#!/usr/bin/env python3
"""
Art as an Alternative Investment - DEFINITIVE Chart Generation
Data sources:
  - Artprice.xlsx: Artprice100© AND S&P 500, both base 100 in Jan 2000
  - CPIAUCSL.csv: US CPI (FRED)
  - Statista PDF (study_id56746): market size, geography, segments
Navy / Black / White color scheme
"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np
import pandas as pd
import os

# ── Colors ─────────────────────────────────────────────────────────────
NAVY_DARK  = '#0B1929'; NAVY = '#1B2A4A'; NAVY_MED = '#2C4A6E'; NAVY_LIGHT = '#3D6A92'
STEEL = '#5A8FB8'; ICE = '#7DB4D8'; PALE = '#A8D0E6'
BLACK = '#111111'; DARK_GREY = '#444444'; MID_GREY = '#888888'; LIGHT_GREY = '#CCCCCC'
WHITE = '#FFFFFF'; BG = '#F7F9FC'; RED_ACCENT = '#C0392B'

plt.rcParams.update({
    'font.family': 'DejaVu Sans', 'font.size': 10, 'axes.titlesize': 13,
    'axes.titleweight': 'bold', 'axes.labelsize': 11, 'figure.facecolor': WHITE,
    'axes.facecolor': BG, 'axes.grid': True, 'grid.alpha': 0.25, 'grid.linestyle': '--',
    'grid.color': LIGHT_GREY, 'axes.edgecolor': LIGHT_GREY, 'axes.labelcolor': DARK_GREY,
    'xtick.color': DARK_GREY, 'ytick.color': DARK_GREY, 'text.color': BLACK,
})
output_dir = '/home/claude/charts'
os.makedirs(output_dir, exist_ok=True)

# ══════════════════════════════════════════════════════════════════════
# LOAD DATA
# ══════════════════════════════════════════════════════════════════════

# --- Both indices from Artprice.xlsx (base 100, Jan 2000) ---
df = pd.read_excel('/mnt/user-data/uploads/Artprice.xlsx')
years = [int(c) for c in df.columns[1:]]
art_values = [float(df.iloc[0][c]) for c in df.columns[1:]]  # Artprice100
sp_values  = [float(df.iloc[1][c]) for c in df.columns[1:]]  # S&P 500

# Annual returns
art_returns = [(art_values[i]/art_values[i-1]-1)*100 for i in range(1, len(art_values))]
sp_returns  = [(sp_values[i]/sp_values[i-1]-1)*100 for i in range(1, len(sp_values))]
return_years = years[1:]  # 2001-2026

corr = np.corrcoef(art_returns, sp_returns)[0, 1]

# --- CPI (CPIAUCSL.csv) ---
cpi_df = pd.read_csv('/mnt/user-data/uploads/CPIAUCSL.csv')
cpi_df['observation_date'] = pd.to_datetime(cpi_df['observation_date'])
cpi_df['Year'] = cpi_df['observation_date'].dt.year
cpi_jan = cpi_df[cpi_df['observation_date'].dt.month == 1].copy()
cpi_jan = cpi_jan[cpi_jan['Year'].between(2000, 2026)].reset_index(drop=True)
inflation_years = [int(cpi_jan.iloc[i]['Year']) for i in range(1, len(cpi_jan))]
inflation_rates = [(cpi_jan.iloc[i]['CPIAUCSL']/cpi_jan.iloc[i-1]['CPIAUCSL']-1)*100 for i in range(1, len(cpi_jan))]

# --- Statista PDF data ---
market_years = list(range(2007, 2025))
market_sales = [66, 62, 39.5, 57, 64.6, 56.7, 63.3, 68.2, 63.8, 56.9, 63.7, 67.7, 64.4, 50.3, 66.1, 68.1, 65.2, 57.5]
market_volume = [49.8, 43.7, 31, 35.1, 36.8, 35.5, 36.5, 38.8, 38.1, 36.1, 39, 39.8, 40.5, 31.4, 37.3, 37.8, 39.4, 40.5]
geo_labels = ['United States', 'United Kingdom', 'China', 'France', 'Switzerland', 'Germany', 'Other']
geo_shares = [43, 18, 15, 7, 3, 3, 11]
seg_labels = ['Post-War', 'Modern', 'Contemporary', 'Impressionist &\nPost-Impressionist', 'Other Old Masters', 'European\nOld Masters']
seg_shares = [36, 25, 16, 14, 5, 4]

# ══════════════════════════════════════════════════════════════════════
# CHART 1: Global Art Market Value + Volume
# ══════════════════════════════════════════════════════════════════════
fig, ax1 = plt.subplots(figsize=(11, 5.5))
ax1.bar(market_years, market_sales, color=NAVY, alpha=0.9, width=0.7, edgecolor=WHITE, linewidth=0.5, label='Market Value ($B)')
ax1.set_xlabel('Year'); ax1.set_ylabel('Sales Value (Billion USD)', color=NAVY)
ax1.set_ylim(0, 80)
ax1.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'${x:.0f}B'))
ax1.tick_params(axis='y', labelcolor=NAVY)
ax2 = ax1.twinx()
ax2.plot(market_years, market_volume, color=STEEL, linewidth=2.5, marker='o', markersize=5,
         markerfacecolor=WHITE, markeredgecolor=STEEL, markeredgewidth=1.5, label='Transactions (M)')
ax2.set_ylabel('Transactions (Millions)', color=STEEL)
ax2.tick_params(axis='y', labelcolor=STEEL); ax2.set_ylim(20, 55)
ax1.set_title('Global Art Market: Sales Value and Transaction Volume (2007\u20132024)', pad=15, color=NAVY_DARK)
ax1.annotate('Financial\nCrisis', xy=(2009, 39.5), xytext=(2009, 50),
             arrowprops=dict(arrowstyle='->', color=RED_ACCENT, lw=1.5), fontsize=8, color=RED_ACCENT, ha='center', fontweight='bold')
ax1.annotate('COVID-19', xy=(2020, 50.3), xytext=(2020.5, 42),
             arrowprops=dict(arrowstyle='->', color=RED_ACCENT, lw=1.5), fontsize=8, color=RED_ACCENT, ha='center', fontweight='bold')
lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax1.legend(lines1+lines2, labels1+labels2, loc='upper left', framealpha=0.95, edgecolor=LIGHT_GREY)
plt.figtext(0.99, 0.01, 'Source: Art Basel, Arts Economics, UBS via Statista', ha='right', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/01_market_evolution.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 1 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 2: Artprice100 vs S&P 500 Cumulative (both from Artprice.xlsx)
# ══════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(10, 5.5))
ax.plot(years, art_values, color=NAVY, linewidth=2.8, label='Artprice100\u00A9 (Blue-Chip Art)')
ax.plot(years, sp_values, color=STEEL, linewidth=2.8, label='S&P 500', linestyle='--')
ax.fill_between(years, art_values, alpha=0.10, color=NAVY)
ax.fill_between(years, sp_values, alpha=0.06, color=STEEL)
ax.axhline(y=100, color=MID_GREY, linestyle=':', alpha=0.5)
ax.set_xlabel('Year'); ax.set_ylabel('Index Value (Base 100 = Jan 2000)')
ax.set_title('Cumulative Performance: ArtPrice 100 vs. S&P 500 (2000\u20132026)', pad=15, color=NAVY_DARK)
ax.legend(loc='upper left', framealpha=0.95, edgecolor=LIGHT_GREY)
ax.annotate(f'ArtPrice: {art_values[-1]:.0f}', xy=(years[-1], art_values[-1]),
            xytext=(years[-1]+0.5, art_values[-1]+20), fontsize=10, fontweight='bold', color=NAVY)
ax.annotate(f'S&P 500: {sp_values[-1]:.0f}', xy=(years[-1], sp_values[-1]),
            xytext=(years[-1]+0.5, sp_values[-1]+20), fontsize=10, fontweight='bold', color=STEEL)
plt.figtext(0.99, 0.01, 'Source: Artprice.xlsx (both indices base 100, Jan 2000)', ha='right', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/02_art_vs_sp500.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 2 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 3: Annual Returns
# ══════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(13, 5))
x = np.arange(len(return_years)); w = 0.35
ax.bar(x - w/2, art_returns, w, label='Artprice100\u00A9', color=NAVY, alpha=0.9, edgecolor=WHITE, linewidth=0.3)
ax.bar(x + w/2, sp_returns, w, label='S&P 500', color=STEEL, alpha=0.9, edgecolor=WHITE, linewidth=0.3)
ax.set_xlabel('Year'); ax.set_ylabel('Annual Return (%)')
ax.set_title(f'Annual Returns: ArtPrice 100 vs. S&P 500 ({return_years[0]}\u2013{return_years[-1]})', pad=15, color=NAVY_DARK)
ax.set_xticks(x[::2]); ax.set_xticklabels([str(y) for y in return_years[::2]], rotation=45)
ax.axhline(y=0, color=BLACK, linewidth=0.8)
ax.legend(loc='lower left', framealpha=0.95, edgecolor=LIGHT_GREY)
plt.figtext(0.99, 0.01, 'Source: Artprice.xlsx', ha='right', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/03_annual_returns.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 3 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 4: Geography
# ══════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(7, 7))
colors_geo = [NAVY_DARK, NAVY, NAVY_MED, NAVY_LIGHT, STEEL, ICE, PALE]
wedges, texts, autotexts = ax.pie(geo_shares, labels=geo_labels, autopct='%1.0f%%',
    colors=colors_geo, startangle=140, pctdistance=0.8,
    wedgeprops=dict(width=0.45, edgecolor=WHITE, linewidth=2.5))
for t in texts: t.set_fontsize(9); t.set_color(DARK_GREY)
for t in autotexts: t.set_fontsize(10); t.set_fontweight('bold'); t.set_color(WHITE)
ax.set_title('Global Art Market Share by Geography (2024)', pad=20, fontsize=13, fontweight='bold', color=NAVY_DARK)
plt.figtext(0.5, 0.02, 'Source: Statista (Art Basel, Arts Economics, UBS)', ha='center', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/04_geography.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 4 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 5: Segments
# ══════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(9, 4.5))
colors_seg = [NAVY_DARK, NAVY, NAVY_MED, NAVY_LIGHT, STEEL, ICE]
y_pos = np.arange(len(seg_labels))
bars = ax.barh(y_pos, seg_shares, color=colors_seg, edgecolor=WHITE, height=0.6, linewidth=0.5)
ax.set_yticks(y_pos); ax.set_yticklabels(seg_labels)
ax.set_xlabel('Share of Fine Art Auction Revenue (%)')
ax.set_title('Fine Art Auction Revenue by Sector (2024)', pad=15, color=NAVY_DARK)
ax.set_xlim(0, 45)
for bar, val in zip(bars, seg_shares):
    ax.text(bar.get_width()+1, bar.get_y()+bar.get_height()/2, f'{val}%', va='center', fontweight='bold', fontsize=10, color=NAVY_DARK)
ax.invert_yaxis()
plt.figtext(0.99, 0.01, 'Source: Statista (Art Basel, Artory, Arts Economics, UBS)', ha='right', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/05_segments.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 5 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 6: Case Study (both from Artprice.xlsx base 100)
# ══════════════════════════════════════════════════════════════════════
cs, ce = 2015, 2024
si, ei = years.index(cs), years.index(ce)
art_cs = [50000 * art_values[i] / art_values[si] for i in range(si, ei+1)]
sp_cs  = [50000 * sp_values[i]  / sp_values[si]  for i in range(si, ei+1)]
bond_cs = [50000 * (1.03**i) for i in range(ce-cs+1)]
case_x = list(range(cs, ce+1))

fig, ax = plt.subplots(figsize=(10, 5.5))
ax.plot(case_x, art_cs, color=NAVY, linewidth=2.8, marker='s', markersize=6,
        markerfacecolor=WHITE, markeredgecolor=NAVY, markeredgewidth=1.5, label='Art (Artprice100\u00A9)')
ax.plot(case_x, sp_cs, color=STEEL, linewidth=2.8, marker='o', markersize=6,
        markerfacecolor=WHITE, markeredgecolor=STEEL, markeredgewidth=1.5, label='S&P 500')
ax.plot(case_x, bond_cs, color=MID_GREY, linewidth=2, marker='^', markersize=5,
        markerfacecolor=WHITE, markeredgecolor=MID_GREY, markeredgewidth=1.5, label='Bonds (3% p.a.)', linestyle='--')
ax.axhline(y=50000, color=LIGHT_GREY, linestyle=':', alpha=0.6)
ax.set_xlabel('Year'); ax.set_ylabel('Portfolio Value (\u20AC)')
ax.set_title('Case Study: \u20AC50,000 Investment (2015\u20132024)', pad=15, color=NAVY_DARK)
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'\u20AC{x:,.0f}'))
ax.legend(loc='upper left', framealpha=0.95, edgecolor=LIGHT_GREY)
for val, color in [(art_cs[-1], NAVY), (sp_cs[-1], STEEL), (bond_cs[-1], MID_GREY)]:
    ax.annotate(f'\u20AC{val:,.0f}', xy=(ce+0.15, val), fontsize=9, fontweight='bold', color=color, va='center')
plt.figtext(0.99, 0.01, 'Source: Artprice.xlsx (both indices); Bond return assumed at 3% p.a.', ha='right', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/06_case_study.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 6 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 7: Return Distribution
# ══════════════════════════════════════════════════════════════════════
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
bins_a = np.arange(min(art_returns)-5, max(art_returns)+10, 5)
bins_s = np.arange(min(sp_returns)-5, max(sp_returns)+10, 5)
ax1.hist(art_returns, bins=bins_a, color=NAVY, alpha=0.85, edgecolor=WHITE, linewidth=0.5)
ax1.axvline(np.mean(art_returns), color=BLACK, linestyle='--', linewidth=2, label=f'Mean: {np.mean(art_returns):.1f}%')
ax1.set_title('Artprice100\u00A9 Return Distribution', color=NAVY_DARK)
ax1.set_xlabel('Annual Return (%)'); ax1.set_ylabel('Frequency'); ax1.legend(framealpha=0.9, edgecolor=LIGHT_GREY)
ax2.hist(sp_returns, bins=bins_s, color=STEEL, alpha=0.85, edgecolor=WHITE, linewidth=0.5)
ax2.axvline(np.mean(sp_returns), color=BLACK, linestyle='--', linewidth=2, label=f'Mean: {np.mean(sp_returns):.1f}%')
ax2.set_title('S&P 500 Return Distribution', color=NAVY_DARK)
ax2.set_xlabel('Annual Return (%)'); ax2.set_ylabel('Frequency'); ax2.legend(framealpha=0.9, edgecolor=LIGHT_GREY)
plt.suptitle(f'Distribution of Annual Returns ({return_years[0]}\u2013{return_years[-1]})', fontsize=13, fontweight='bold', y=1.02, color=NAVY_DARK)
plt.tight_layout(); plt.savefig(f'{output_dir}/07_return_distribution.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 7 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 8: Monte Carlo
# ══════════════════════════════════════════════════════════════════════
np.random.seed(42)
stock_mu = np.mean(sp_returns)/100; stock_sig = np.std(sp_returns)/100
art_mu = np.mean(art_returns)/100; art_sig = np.std(art_returns)/100
bond_mu_mc, bond_sig_mc = 0.035, 0.05
trad_f, div_f = [], []
for _ in range(1000):
    sr = np.random.normal(stock_mu, stock_sig, 20)
    br = np.random.normal(bond_mu_mc, bond_sig_mc, 20)
    ar = np.random.normal(art_mu, art_sig, 20)
    t, d = 100000, 100000
    for y in range(20):
        t *= (1 + 0.6*sr[y] + 0.4*br[y])
        d *= (1 + 0.5*sr[y] + 0.3*br[y] + 0.2*ar[y])
    trad_f.append(t); div_f.append(d)

fig, ax = plt.subplots(figsize=(10, 5.5))
bins_p = np.linspace(0, max(max(trad_f), max(div_f))*0.85, 50)
ax.hist(trad_f, bins=bins_p, alpha=0.55, color=STEEL, label='Traditional 60/40 (Stocks/Bonds)', edgecolor=WHITE, linewidth=0.3)
ax.hist(div_f, bins=bins_p, alpha=0.65, color=NAVY, label='Diversified 50/30/20 (Stocks/Bonds/Art)', edgecolor=WHITE, linewidth=0.3)
ax.axvline(np.median(trad_f), color=STEEL, linestyle='--', linewidth=2.5)
ax.axvline(np.median(div_f), color=NAVY, linestyle='--', linewidth=2.5)
ax.set_xlabel('Final Portfolio Value ($)'); ax.set_ylabel('Frequency')
ax.set_title('Monte Carlo Simulation: Portfolio with vs. without Art (20-Year, $100k Initial)', pad=15, color=NAVY_DARK)
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'${x/1000:.0f}k'))
ax.legend(framealpha=0.95, edgecolor=LIGHT_GREY)
stats_text = (f'Traditional 60/40:\n  Median: ${np.median(trad_f):,.0f}\n  Std Dev: ${np.std(trad_f):,.0f}\n'
              f'Diversified 50/30/20:\n  Median: ${np.median(div_f):,.0f}\n  Std Dev: ${np.std(div_f):,.0f}')
ax.text(0.98, 0.95, stats_text, transform=ax.transAxes, fontsize=8, va='top', ha='right',
        bbox=dict(boxstyle='round,pad=0.5', facecolor=WHITE, alpha=0.95, edgecolor=LIGHT_GREY))
plt.figtext(0.99, 0.01,
    f'Parameters from Artprice.xlsx: Stocks \u03BC={stock_mu:.1%}/\u03C3={stock_sig:.1%}, Art \u03BC={art_mu:.1%}/\u03C3={art_sig:.1%}, Bonds \u03BC=3.5%/\u03C3=5%. n=1,000.',
    ha='right', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/08_portfolio_simulation.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 8 done")

# ══════════════════════════════════════════════════════════════════════
# CHART 9: Real (CPI-adjusted) returns
# ══════════════════════════════════════════════════════════════════════
real_art, real_sp, real_years = [], [], []
for i, y in enumerate(return_years):
    if y in inflation_years:
        infl = inflation_rates[inflation_years.index(y)]
        real_art.append(art_returns[i] - infl)
        real_sp.append(sp_returns[i] - infl)
        real_years.append(y)
fig, ax = plt.subplots(figsize=(10, 5))
ax.plot(real_years, np.cumsum(real_art), color=NAVY, linewidth=2.8, marker='s', markersize=4,
        markerfacecolor=WHITE, markeredgecolor=NAVY, markeredgewidth=1.2, label='ArtPrice 100')
ax.plot(real_years, np.cumsum(real_sp), color=STEEL, linewidth=2.8, marker='o', markersize=4,
        markerfacecolor=WHITE, markeredgecolor=STEEL, markeredgewidth=1.2, label='S&P 500', linestyle='--')
ax.axhline(y=0, color=LIGHT_GREY, linestyle=':', alpha=0.6)
ax.set_xlabel('Year'); ax.set_ylabel('Cumulative Real Return (%)')
ax.set_title('Cumulative Inflation-Adjusted Returns: Artprice100\u00A9 vs. S&P 500', pad=15, color=NAVY_DARK)
ax.legend(loc='upper left', framealpha=0.95, edgecolor=LIGHT_GREY)
plt.figtext(0.99, 0.01, 'Sources: Artprice.xlsx; CPIAUCSL.csv (FRED)', ha='right', fontsize=7, color=MID_GREY)
plt.tight_layout(); plt.savefig(f'{output_dir}/09_real_returns.png', dpi=200, bbox_inches='tight'); plt.close()
print("Chart 9 done")

# ══════════════════════════════════════════════════════════════════════
# STATS
# ══════════════════════════════════════════════════════════════════════
rf = 3.0
sharpe_art = (np.mean(art_returns) - rf) / np.std(art_returns)
sharpe_sp = (np.mean(sp_returns) - rf) / np.std(sp_returns)
print(f"\n{'='*60}")
print(f"KEY STATS (FROM Artprice.xlsx - both indices base 100)")
print(f"{'='*60}")
print(f"Art: mean={np.mean(art_returns):.2f}%, std={np.std(art_returns):.2f}%, final={art_values[-1]}, Sharpe={sharpe_art:.3f}")
print(f"S&P: mean={np.mean(sp_returns):.2f}%, std={np.std(sp_returns):.2f}%, final={sp_values[-1]}, Sharpe={sharpe_sp:.3f}")
print(f"Correlation: {corr:.3f}")
print(f"Real art mean: {np.mean(real_art):.2f}%, Real S&P mean: {np.mean(real_sp):.2f}%")
print(f"Case: Art=\u20AC{art_cs[-1]:,.0f}, S&P=\u20AC{sp_cs[-1]:,.0f}, Bonds=\u20AC{bond_cs[-1]:,.0f}")
print(f"MC: Trad median=${np.median(trad_f):,.0f}, Div median=${np.median(div_f):,.0f}")
