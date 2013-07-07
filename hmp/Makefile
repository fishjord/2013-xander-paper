NAME= hmp_mock
JAR_DIR=$(realpath ../jars)
SEQFILE=trimmed_hmp_mock.fasta
FILTER_SIZE= 34 # 2**FILTER_SIZE, 38 = 32 gigs, 37 = 16 gigs, 36 = 8 gigs, 35 = 4 gigs
K_SIZE= 21

genes= rplb

export

all: $(genes)

.PHONY: $(genes)

bloom: $(NAME).bloom

$(NAME).bloom: $(SEQFILE)
	java -Xmx4g -jar $(JAR_DIR)/hmmgs.jar build $(SEQFILE) $(NAME).bloom $(K_SIZE) $(FILTER_SIZE)

$(genes): bloom
	cd $@ && $(MAKE) --makefile ../gene.Makefile BLOOM=$(realpath $(NAME).bloom)

$(SEQFILE): SRR172903.fastq.gz SRR172902.fastq.gz
	java -cp $(JAR_DIR)/ReadSeq.jar edu.msu.cme.rdp.readseq.utils.QualityTrimmer -i '#' *.fastq.gz &&\
	cat trimmed_*.fastq.fasta > trimmed_hmp_mock.fasta &&\
	rm trimmed_*.fastq.fasta

%.fastq.gz:
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR172/SRR172903/SRR172903.fastq.gz
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR172/SRR172902/SRR172902.fastq.gz

nirk_starts.txt: $(SEQFILE)
	java -Xmx2g -jar $(JAR_DIR)/KmerFilter.jar fast_kmer_filter --threads 4 -a -o nirk_starts.txt $(K_SIZE) $(SEQFILE) nirk=/home/fishjord/nirk/nirk_startpoint_refs.sto
