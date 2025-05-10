import pandas as pd
import json
from mlxtend.frequent_patterns import fpgrowth, association_rules
from mlxtend.preprocessing import TransactionEncoder
from pymining import seqmining

# 1. Caricamento del file JSON
with open('data.json') as f:
    data = json.load(f)

events = data.get('buckets', {}).get('aw-watcher-window_Macb00k-di-Andrea.local', {}).get('events', [])

# 2. Creazione del DataFrame
df = pd.DataFrame([{
    'timestamp': e['timestamp'],
    'duration': e['duration'],
    'app': e['data'].get('app', ''),
    'title': e['data'].get('title', '')
} for e in events])

# 3. Creazione delle transazioni: lista di app per timestamp
transactions = df.groupby('timestamp')['app'].unique().tolist()

# 4. Trasformazione in formato binario
te = TransactionEncoder()
te_ary = te.fit(transactions).transform(transactions)
df_encoded = pd.DataFrame(te_ary, columns=te.columns_)

# 5. FP-Growth
frequent_itemsets = fpgrowth(df_encoded, min_support=0.15, use_colnames=True)

# 6. Regole di associazione
rules = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.6)

# 7. Visualizzazione
print("Itemset frequenti:")
print(frequent_itemsets.sort_values(by='support', ascending=False))

print("\nRegole di associazione:")
print(rules[['antecedents', 'consequents', 'support', 'confidence', 'lift']])

# 8. Mining sequenze frequenti (senza divisione in sessioni)
sequences = df.groupby('timestamp')['app'].apply(list).tolist()

frequent_patterns = seqmining.freq_seq_enum(sequences, min_support=2)

print("\nPattern sequenziali frequenti:")
for pattern, support in sorted(frequent_patterns, key=lambda x: -x[1]):
    print(f"{pattern} -> support: {support}")
