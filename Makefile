#Customised-Ver

# === CONFIGURATION ===
NAME_SERVER = server
NAME_CLIENT = client

CC = gcc
CFLAGS = -Wall -Wextra -Werror -Ilibft

SRC_SERVER = server.c
SRC_CLIENT = client.c

OBJ_SERVER = $(SRC_SERVER:.c=.o)
OBJ_CLIENT = $(SRC_CLIENT:.c=.o)

LIBFT_DIR = ./libft
LIBFT = $(LIBFT_DIR)/libft.a

%.o: %.c
	@$(CC) $(CFLAGS) -c $< -o $@

# === COLORS ===
GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m

# === HELPERS ===

define SPINNER
	@bash -c 'spin() { chars="/-\|"; while :; do for c in $$chars; do printf "\r$(1) $$c "; sleep 0.1; done; done }; spin' &
	@SPIN_PID=$$!; trap "kill $$SPIN_PID 2>/dev/null" EXIT; sleep $(2); kill $$SPIN_PID; wait $$SPIN_PID 2>/dev/null; trap - EXIT
endef

define PROGRESS_BAR
	@printf "$(YELLOW)⏳ $(1)$(NC)\n"
	@bash -c 'for i in {1..20}; do \
		done=""; \
		empty=""; \
		for ((j=0;j<i;j++)); do done=$$done"█"; done; \
		for ((j=i;j<20;j++)); do empty=$$empty" "; done; \
		percent=$$((i * 5)); \
		printf "\r[%-20s] %3d%%" "$$done$$empty" "$$percent"; \
		sleep 0.05; \
	done; echo'
endef


define STEP
	@echo "$(BLUE)🚧 $(1)...$(NC)"
endef

define SUCCESS
	@echo "$(GREEN)✔️  $(1) done!$(NC)"
endef

define START
	@echo "$(BLUE)🚀 Building $(1)...$(NC)"
endef

define DONE
	@echo "$(GREEN)🎉 Build complete!$(NC)"
endef


# === TARGETS ===

all: $(LIBFT) $(NAME_SERVER) $(NAME_CLIENT)
	$(call DONE)

$(NAME_SERVER): $(OBJ_SERVER) $(LIBFT)
	$(call START, $(NAME_SERVER))
	$(call PROGRESS_BAR,Compiling server)
	$(SPINNER "🔧 Linking server" 1)
	@$(CC) $(CFLAGS) -o $(NAME_SERVER) $(OBJ_SERVER) -L$(LIBFT_DIR) -lft
	$(call SUCCESS, $(NAME_SERVER))

$(NAME_CLIENT): $(OBJ_CLIENT) $(LIBFT)
	$(call START, $(NAME_CLIENT))
	$(call PROGRESS_BAR,Compiling client)
	$(SPINNER "🔧 Linking client" 1)
	@$(CC) $(CFLAGS) -o $(NAME_CLIENT) $(OBJ_CLIENT) -L$(LIBFT_DIR) -lft
	$(call SUCCESS, $(NAME_CLIENT))

$(LIBFT):
	$(call STEP,📚 Building libft)
	$(call PROGRESS_BAR,Compiling libft)
	@make -C $(LIBFT_DIR) --silent

clean:
	@echo "$(RED)🧹 Cleaning object files...$(NC)"
	@rm -f $(OBJ_SERVER) $(OBJ_CLIENT)
	@$(MAKE) -s -C $(LIBFT_DIR) clean
	@echo "$(GREEN)✔️  Clean complete!$(NC)"

fclean: clean
	@echo "$(RED)🗑️  Removing binaries...$(NC)"
	@rm -f $(NAME_SERVER) $(NAME_CLIENT)
	@$(MAKE) -s -C $(LIBFT_DIR) fclean
	@echo "$(GREEN)✔️  Full clean complete!$(NC)"


re: fclean all

.PHONY: all clean fclean re
