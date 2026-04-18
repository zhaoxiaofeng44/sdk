import os
from pathlib import Path

import torch
from seqeval.metrics import classification_report, accuracy_score
from datasets import load_dataset
from transformers import (
    AutoTokenizer,
    AutoModelForTokenClassification,
    Trainer,
    TrainingArguments,
    DataCollatorForTokenClassification,
)

# 1️⃣ 路径
DATA_DIR = Path("data")
assert (DATA_DIR / "train.tsv").exists(), "train.tsv 没找"
assert (DATA_DIR / "dev.tsv").exists(), "dev.tsv 没找"

# 2️⃣ 载入数据
dataset = load_dataset(
    "csv",
    data_files={
        "train": str(DATA_DIR / "train.tsv"),
        "validation": str(DATA_DIR / "dev.tsv"),
    },
    delimiter="\t",
    column_names=["sentence", "labels"],
)

# 3️⃣ 标签映射
all_labels = sorted(
    set(
        l
        for split in ["train", "validation"]
        for lbls in dataset[split]["labels"]
        for l in lbls.split()
    )
)
label2id = {l: i for i, l in enumerate(all_labels)}
id2label = {i: l for l, i in label2id.items()}

def encode_labels(example):
    example["labels"] = [label2id[l] for l in example["labels"].split()]
    return example

dataset = dataset.map(encode_labels)

# 4️⃣ tokenizer & model
MODEL = "bert-base-chinese"
tokenizer = AutoTokenizer.from_pretrained(MODEL)
model = AutoModelForTokenClassification.from_pretrained(
    MODEL,
    num_labels=len(all_labels),
    id2label=id2label,
    label2id=label2id,
)

# 5️⃣ 直接 tokenization
def tokenize_and_align(example):
    tokens = tokenizer(
        example["sentence"],
        truncation=True,
        is_split_into_words=False,
    )
    # 每个字符一个 token
    tokens["labels"] = example["labels"]
    return tokens

dataset = dataset.map(tokenize_and_align, batched=True)
data_collator = DataCollatorForTokenClassification(tokenizer)

# 6️⃣ 训练 args
output_dir = Path("./bert_char_pos")
output_dir.mkdir(exist_ok=True)

training_args = TrainingArguments(
    output_dir=str(output_dir),
    evaluation_strategy="epoch",
    learning_rate=2e-5,
    per_device_train_batch_size=16,
    per_device_eval_batch_size=32,
    num_train_epochs=5,
    weight_decay=0.01,
    logging_steps=50,
    fp16=(torch.backends.mps.is_available() or torch.backends.neutron.is_available()),
    push_to_hub=False,
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset["train"],
    eval_dataset=dataset["validation"],
    tokenizer=tokenizer,
    data_collator=data_collator,
)

# 7️⃣ 训练
trainer.train()

# 8️⃣ 评估
preds = trainer.predict(dataset["validation"])
pred_labels = [
    [id2label[pred] for pred in seq.argmax(-1) if pred != -100]
    for seq in preds.predictions
]
true_labels = [
    [id2label[t] for t in seq]
    for seq in dataset["validation"]["labels"]
]

print("\n=== 评估报告 ===")
print(classification_report(true_labels, pred_labels))
print(f"\nAccuracy: {accuracy_score(true_labels, pred_labels):.4f}")

# 9️⃣ 保存
model.save_pretrained(str(output_dir))
tokenizer.save_pretrained(str(output_dir))
