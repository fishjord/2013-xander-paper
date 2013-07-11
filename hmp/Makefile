KHMER= /scratch/fishjord/apps/khmer
GLOWING_SAKANA= /work/fishjord/other_projects/python_scripts
NAME= hmp_mock
JAR_DIR=$(realpath ../jars)
SEQFILE=trimmed_hmp_mock.fasta
FILTER_SIZE= 34 # 2**FILTER_SIZE, 38 = 32 gigs, 37 = 16 gigs, 36 = 8 gigs, 35 = 4 gigs
K_SIZE= 30
BLOOM_SEQFILE= $(SEQFILE)

genes= rplb nirk

export

.PHONY: all $(genes) clean $(addsuffix .clean,$(genes)) bloom

all: $(genes)

bloom: $(NAME).bloom

$(NAME).bloom: $(BLOOM_SEQFILE)
	java -Xmx4g -jar $(JAR_DIR)/hmmgs.jar build $(BLOOM_SEQFILE) $(NAME).bloom $(K_SIZE) $(FILTER_SIZE)

%/gene_starts.txt: filtered_starts.txt
	grep $* filtered_starts.txt > $*/gene_starts.txt

.SECONDEXPANSION:

$(genes): bloom $$@/gene_starts.txt
	cd $@ && $(MAKE) --makefile ../gene.Makefile BLOOM=$(realpath $(NAME).bloom)

$(SEQFILE).keep: $(SEQFILE)
	$(KHMER)/scripts/normalize-by-median.py -C 20 -x 1e9 $(SEQFILE) &> diginorm_log.txt

$(SEQFILE): SRR172903.fastq.gz SRR172902.fastq.gz
	java -cp $(JAR_DIR)/ReadSeq.jar edu.msu.cme.rdp.readseq.utils.QualityTrimmer -i '#' *.fastq.gz &&\
	cat trimmed_*.fastq.fasta > trimmed_hmp_mock.fasta &&\
	rm trimmed_*.fastq.fasta

%.fastq.gz:
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR172/SRR172903/SRR172903.fastq.gz
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR172/SRR172902/SRR172902.fastq.gz

filtered_starts.txt: starts.txt
	$(GLOWING_SAKANA)/hmmgs/filter_starts.py starts.txt > filtered_starts.txt

starts.txt: $(NAME).bloom
	java -Xmx2g  -jar $(JAR_DIR)/KmerFilter.jar fast_kmer_filter --threads=4 -a $(K_SIZE) -o starts.txt $(SEQFILE).keep $(foreach gene,$(genes),$(gene)=$(gene)/ref_aligned.faa)

clean: FORCE
	$(foreach gene,$(genes),cd $(gene); $(MAKE) --makefile ../gene.Makefile clean; cd -;)

FORCE:
