######### 这里面好像搞乱了

source activate samtools
samtools depth -a test.sort.markdup.bam > test.sort.markdup.bam-test.txt


### 测序深度
awk -F "\t" 'BEGIN{a=0;b=0}{if($3>0){a++;b+=$3}} END {print b/a}' test.sort.markdup.bam-test.txt >> map-avedepth; #统计比对到参考基因组的位点的平均测序深度
awk -F "\t" 'BEGIN{a=0}{if($3>0){a+=$3}} END {print a/1672146419}' test.sort.markdup.bam-test.txt >> all-avedepth; #统计基因组所有位点的平均测序深度（包括未测到的）

### 覆盖度
awk -F "\t" 'BEGIN{a=0}{if($3>0){a++}} END {print a/NR}' test.sort.markdup.bam-test.txt


### mapping率
#计算每个样本的mapping rate，生成tax文件
for file in *.sort.markdup.bam; do
name=$(basename "$file" | cut -d '.' -f 1) #提取样本名（不包含扩展名）
samtools flagstat -@8 "$file" > "$name".maprate.tax
done

#统计每个tax文件中的mapping rate
for file in /data01/wangyf/project2/CyprinusCarpio/5.markdup/*.maprate.tax; do
name=$(basename "$file" | cut -d '.' -f 1)
result=$(awk 'FNR==5 {print substr($0, 23, 5)}' "$file")
echo "${name}: ${result}%"
done >>maprate-result


### 重复率
for file in /data01/wangyf/project2/CyprinusCarpio/3.fastp/*.json; do \
  if [ -f "$file" ]; then \
  filename="$file"; prefix=$(basename "$filename" .json); \
  dup=$(sed -n '36p' "$file"); \
  printf "%s\t%s\\n" "$prefix" "$dup" ;\
fi ;done > datainfo.txt
